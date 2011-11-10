class rdiff-backup::params {

  # for the default pool (the first one)
  $dir = $rdiff_backup_dir ? {
    ""      => '/srv/rdiff-backup',
    default => $rdiff_backup_dir,
  }

  # relative to the default pool (the first one)
  $max_process = $rdiff_backup_max_process ? {
    ""      => 5,
    default => $rdiff_backup_max_process,
  }

  $cron_hour = $rdiff_backup_cron_hour ? {
    ""      => 1,
    default => $rdiff_backup_cron_hour,
  }

  $cron_minute = $rdiff_backup_cron_minute ? {
    ""      => 0,
    default => $rdiff_backup_cron_minute,
  }

  $logs_dir = $rdiff_backup_logs_dir ? {
    ""      => '/var/log/rdiff-backup',
    default => $rdiff_backup_logs_dir,
  }

  $logs_age = $rdiff_backup_logs_age ? {
    ""      => '5d',
    default => $rdiff_backup_logs_age,
  }

  $download_url = $rdiff_backup_download_url ? {
    ""      => 'http://ftp.igh.cnrs.fr/pub/nongnu/rdiff-backup/',
    default => $rdiff_backup_download_url,
  }

}
