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
    ""      => '/var/log/rdiff-backups',
    default => $rdiff_backup_logs_dir,
  }

}
