define rdiff-backup::server::install ($ensure=present) {

  $version = "rdiff-backup-${name}"

  archive{"${version}":
    ensure   => $ensure,
    checksum => false,
    url      => "${params::download_url}${version}.tar.gz",
    target   => '/opt/rdiff-backup',
    notify   => $ensure ? {
      present => Exec["install ${version}"],
      default => undef
    },
    require  => File["/opt/rdiff-backup"],
  }

  exec {"install ${version}":
    command     => "cd /opt/rdiff-backup/${version} && python setup.py install --prefix=/opt/rdiff-backup/${version}",
    unless      => "test -f /opt/rdiff-backup/${version}/bin/rdiff-backup",
    refreshonly => true,
    require     => Package["librsync-devel", "python-devel"],
  }

}
