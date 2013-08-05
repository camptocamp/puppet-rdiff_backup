define rdiff_backup::pool (
  $max_process,
  $destination_dir,
  $ensure=present,
) {

  concat::fragment {$name:
    ensure  => $ensure,
    target  => '/etc/multiprocessing-rdiff-backup.conf',
    content => template('rdiff_backup/pool.erb'),
  }

}
