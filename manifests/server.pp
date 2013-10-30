class rdiff_backup::server (
  $dir = $rdiff_backup::params::dir,
  $logs_dir = $rdiff_backup::params::logs_dir,
  $logs_age = $rdiff_backup::params::logs_age,
  $max_process = $rdiff_backup::params::max_process,
  $cron_hour = $rdiff_backup::params::cron_hour,
  $cron_minute = $rdiff_backup::params::cron_minute,
) inherits ::rdiff_backup::params {

  validate_absolute_path($dir)
  validate_absolute_path($logs_dir)

  include ::buildenv::c
  include ::python::dev


  file {'/opt/rdiff-backup':
    ensure => directory,
  }

  file {'/etc/rdiff-backup.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    recurse => true,
    purge   => true,
    force   => true,
  }

  if defined (Package['curl']) {
    notice 'package curl is already defined'
  } else {
    package {'curl':
      ensure => present,
    }
  }

  case $::operatingsystem {
    Debian: {
      package {
        'librsync-dev':  ensure => present, alias => 'librsync-devel';
      }
    }
    RedHat: {
      package {
        'librsync-devel': ensure => present, alias => 'librsync-devel';
      }
    }
  }

  file {$dir:
    ensure => directory,
  }

  file {$logs_dir:
    ensure => directory,
  }

  tidy {$logs_dir:
    age     => $logs_age,
    recurse => true,
  }

  rdiff_backup::pool {'pool1':
    ensure          => present,
    max_process     => $max_process,
    destination_dir => $dir,
  }

  file {'/usr/local/sbin/multiprocessing-rdiff-backup.py':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('rdiff_backup/multiprocessing-rdiff-backup.py.erb'),
  }

  # cron to start multi-thread script
  cron {'start multiprocessing backup script':
    ensure  => present,
    command => '/usr/bin/python /usr/local/sbin/multiprocessing-rdiff-backup.py --all',
    minute  => $cron_minute,
    hour    => $cron_hour,
    user    => 'root',
    require => File['/usr/local/sbin/multiprocessing-rdiff-backup.py'],
  }

  concat {'/etc/multiprocessing-rdiff-backup.conf':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

}
