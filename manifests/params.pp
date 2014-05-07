class rdiff_backup::params {

  # for the default pool (the first one)
  $dir = '/srv/rdiff-backup'

  # relative to the default pool (the first one)
  $max_process = 5

  $cron_hour = 1

  $cron_minute = 0

  $logs_dir = '/var/log/rdiff-backup'

  $logs_age = '5d'

  $download_url = 'http://ftp.igh.cnrs.fr/pub/nongnu/rdiff-backup/'

}
