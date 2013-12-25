class projects::ledej {
  include dnsmasq
  include heroku
  include redis
  include postgresql
  include elasticsearch
  include python
  include python::virtualenvwrapper
  include nodejs

  # extra
  include chrome
  include firefox
  include hipchat
  include dropbox
  include cyberduck

  python::mkvirtualenv{ 'venv':
    require     => Package['python'],
    ensure      => present,
    systempkgs  => false,
    distribute  => true,
    project_dir => "~/src/ledej",
  }

  python::requirements { 'reqs-dev':
    requirements => "/Users/${::boxen_user}/src/ledej/reqs/dev.txt",
    virtualenv   => 'venv',
    require      => Package['libjpeg'],
  }

  # Homebrew packages
  package { 'gdal':
    require => Package['numpy'],
    ensure => present,
  }
  package {
    [
      'rabbitmq',
      'libjpeg',
      'git-flow',
      'htop-osx',
      'go',
      'python',
      # 'redis',
    ]:
    ensure => present,
  }

  # Gem packages
  package {
    [
      'kicker',
      'foreman',
    ]:
    ensure => present,
    provider => gem,
  }

  # Default NodeJS version
  include nodejs::v0_10
  class { 'nodejs::global': version => 'v0.10' }

  # Node packages
  nodejs::module { 'sass':
    node_version => 'v0.10'
  }

  # Python packages
  package { 'numpy':
    ensure => present,
    provider => pip,
  }
  package {
    [
      'virtualenv',
      'virtualenvwrapper',
    ]:
    require => Package['python'],
    ensure => present,
    provider => pip,
  }

  boxen::project { 'ledej':
    # dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    # python        => '2.7.4',
    source        => 'Ledej/ledej-website',
    require       => Package['libjpeg'],
  }
}
