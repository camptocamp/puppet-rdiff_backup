class rdiff-backup::server {

  include rdiff-backup::params
  include buildenv::c
  include python::dev

  file {"/opt/rdiff-backup":
    ensure => directory,
  }
  
  file {"/etc/rdiff-backup.d":
    ensure  => directory,
    owner   => root,
    group   => root,
    recurse => true,
    purge   => true,
    force   => true,
  }

  if defined (Package["curl"]) {
    notice "package curl is already defined"
  } else {
    package {"curl":
      ensure => present,
    }
  }

  case $operatingsystem {
    Debian: {
      package {
        "librsync-dev":  ensure => present, alias => "librsync-devel";
      }
    }
    RedHat: {
      package {
        "librsync-devel": ensure => present, alias => "librsync-devel";
      }
    }
  }

  file {$params::dir:
    ensure => directory,
  }

  file {$params::logs_dir:
    ensure => directory,
  }

  rdiff-backup::pool {"pool1":
    ensure          => present,
    max_process     => $params::max_process,
    destination_dir => $params::dir,
  }

  file {"/usr/local/sbin/multiprocessing-rdiff-backup.py":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 755,
    source => "puppet:///rdiff-backup/usr/local/sbin/multiprocessing-rdiff-backup.py",
  }
  
  # cron to start multi-thread script
  cron {"start multiprocessing backup script":
    ensure  => present,
    command => "/usr/bin/python /usr/local/sbin/multiprocessing-rdiff-backup.py --all",
    minute  => $params::cron_minute,
    hour    => $params::cron_hour,
    user    => "root",
    require => File["/usr/local/sbin/multiprocessing-rdiff-backup.py"],
  }

}
