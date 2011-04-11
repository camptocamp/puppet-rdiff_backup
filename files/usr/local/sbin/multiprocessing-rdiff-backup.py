#!/usr/bin/env python

import os
import time
import sys
import glob
import shlex
import subprocess
from optparse import OptionParser
import ConfigParser
from multiprocessing import Pool
from commands import getstatusoutput

_RBDIR  = "/opt/rdiff-backup"
_CONFIG = "/etc/multiprocessing-rdiff-backup.conf"

def backup(host):
  
  logFile = "/var/log/rdiff-backup/%s-%s.log" % (
    host['host'], 
    time.strftime("%d-%m-%Y", time.localtime())
  )
  
  args = []
  args.append("%s/rdiff-backup-%s/bin/rdiff-backup" % (_RBDIR, host['version']))
  args.extend(shlex.split(host['args']))
  args.append(host['source'])
  args.append(host['destination'])
 
  env = []
  for l in ["lib", "lib64"]:
    env.append("%s/rdiff-backup-%s/%s/python%s.%s/site-packages" % (
      _RBDIR, host['version'], l, sys.version_info[0], sys.version_info[1]))

  pa = subprocess.Popen(
    args,
    env={"PYTHONPATH": ":".join(env)}, 
    stdout=subprocess.PIPE, 
    stderr=subprocess.PIPE, 
    close_fds=True)

  status = os.waitpid(pa.pid,0)[1]
   
  if not status:
    args = []
    args.append("%s/rdiff-backup-%s/bin/rdiff-backup" % (_RBDIR, host['version']))
    args.extend(["--remove-older-than", host['retention'], "--force", host['destination']])
  
    pb = subprocess.Popen(
      args, 
      env={"PYTHONPATH": ":".join(env)},
      stdout=subprocess.PIPE, 
      stderr=subprocess.PIPE, 
      close_fds=True)  
    
    status = os.waitpid(pb.pid,0)[1]

  # writes a logfile with rdiff-backup stdin and stderr
  flog = open(logFile, 'w')
  flog.write(pa.stdout.read()+pb.stdout.read())
  flog.write("RDIFF-BACKUP-EXIT-STATUS=%s\n" % status) 
  flog.close()

def getBackupList():
  backups = []
  backupList = glob.glob('/etc/rdiff-backup.d/*.conf')
  for backup in backupList:
    config = ConfigParser.ConfigParser()
    config.read(backup)
    backups.append(dict(config.items('hostconfig')))
  return filter(lambda x:x['enable'].lower() == "true", backups)

def readMainConfig():
  if not os.path.exists(_CONFIG):
    print "Main configuration %s not found!" % mainConfig
    sys.exit(1)
  config = ConfigParser.ConfigParser()
  config.read(_CONFIG)
  return dict(config.items('mainconfig'))

if __name__=="__main__":

  # only root can run this script
  if os.getuid():
    print "not root!"
    sys.exit(1)

  options = OptionParser(version="1.0")
  options.add_option("-H", "--host", dest="host", help="launch backup for <host> only")
  (opt, args) = options.parse_args()

  mainConf = readMainConfig()
  nbprocs = int(mainConf['max_process'])
  backups = getBackupList()
  
  if opt.host:
    nbprocs = 1
    backups = filter(lambda x: x['host'] == opt.host, backups)
    if not backups:
      print "Host %s not found!" % opt.host
      sys.exit(1)

  mainConf = readMainConfig()
  pool = Pool(processes=nbprocs)
  pool.map(backup, backups)

