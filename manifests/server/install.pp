define rdiff_backup::server::install (
  $ensure=present,
) {

  include ::rdiff_backup::params

  $version = "rdiff-backup-${name}"

  case $ensure {
    'present': {
      archive{"/opt/rdiff-backup/${version}":
        ensure  => present,
        source  => "${rdiff_backup::params::download_url}${version}.tar.gz",
        notify  => Exec["install ${version}"],
        require => File['/opt/rdiff-backup'],
      }

      exec {"install ${version}":
        cwd         => "/opt/rdiff-backup/${version}",
        command     => "python setup.py install --prefix=/opt/rdiff-backup/${version}",
        unless      => "test -f /opt/rdiff-backup/${version}/bin/rdiff-backup",
        refreshonly => true,
        path        => $::path,
        require     => Package['librsync-devel', 'python-devel'],
      }
    }
    'absent': {
      file {"/opt/rdiff-backup/${version}":
        ensure  => absent,
        backup  => false,
        force   => true,
        recurse => true,
      }

      file {"/usr/src/${version}.tar.gz":
        ensure => absent,
        backup => false,
      }
    }
    default: {
      fail "Unknown ensure ${ensure} for rdiff_backup::server::install"
    }
  }

}
