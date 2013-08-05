define rdiff_backup::conf (
  $version,
  $source,
  $destination,
  $args,
  $retention,
  $ensure=present,
  $enable=true,
) {

  file {"/etc/rdiff-backup.d/${name}.conf":
    ensure  => $ensure,
    content => template('rdiff_backup/hostconfig.erb'),
    require => File['/etc/rdiff-backup.d'],
  }

}
