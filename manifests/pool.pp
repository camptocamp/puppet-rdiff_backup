define rdiff-backup::pool (
  $ensure=present,
  $max_process, 
  $destination_dir) {

  concat::fragment {$name:
    ensure  => $ensure,
    target  => '/etc/multiprocessing-rdiff-backup.conf',
    content => template('rdiff-backup/pool.erb'),
  }

}
