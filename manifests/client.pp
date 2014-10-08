class rdiff_backup::client (
  $ensure=present,
) {
  if defined (Package['rdiff-backup']) {
    notice 'package rdiff-backup is already defined'
  } else {
    package {'rdiff-backup':
      ensure => $ensure,
    }
  }
}
