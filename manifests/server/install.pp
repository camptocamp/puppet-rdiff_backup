define rdiff_backup::server::install (
  $ensure=present,
) {

  include ::rdiff_backup::params

  $version = "rdiff-backup-${name}"

  case $ensure {
    'present': {
      archive{$version:
        ensure   => present,
        checksum => false,
        url      => "${rdiff_backup::params::download_url}${version}.tar.gz",
        target   => '/opt/rdiff-backup',
        notify   => Exec["install ${version}"],
        require  => File['/opt/rdiff-backup'],
      }

      exec {"install ${version}":
        cwd         => "/opt/rdiff-backup/${version}",
        command     => "python setup.py install --prefix=/opt/rdiff-backup/${version}",
        unless      => "test -f /opt/rdiff-backup/${version}/bin/rdiff-backup",
        refreshonly => true,
        require     => Package['librsync-devel', 'python-dev'],
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
