Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

class { 'apt':
  always_apt_update => true,
}

Exec['apt_update'] -> Package <| |>

# https://github.com/puppetlabs/puppetlabs-concat/pull/4
file { '/bin/sh':
  ensure => link,
  target => '/bin/bash',
  before => Class['concat::setup'],
}

package { [
  'git-core',
  'language-pack-de-base',
  'python-beautifulsoup',
  'python-dev',
  'python-imaging',
  'python-virtualenv',
  'vim-nox',
  ] : ensure => installed
}

exec { 'virtualenv /home/vagrant/venv':
  command => 'virtualenv /home/vagrant/venv',
  creates => '/home/vagrant/venv',
  require => Package['python-virtualenv'],
  user    => 'vagrant',
}

include postgresql::server
include postgresql::python

postgresql::db { 'kreuzundquer':
  user     => 'vagrant',
  password => ''
}
