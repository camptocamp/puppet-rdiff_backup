define rdiff-backup::pool (
  $ensure=present,
  $max_process, 
  $destination_dir) {

  common::concatfilepart { $name:
    ensure  => $ensure,
    manage  => true,
    file    => "/etc/multiprocessing-rdiff-backup.conf",
    content => template("rdiff-backup/pool.erb"),
  }

}
