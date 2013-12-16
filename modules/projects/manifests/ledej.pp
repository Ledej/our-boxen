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

  python::mkvirtualenv{ 'venv':
    ensure      => present,
    systempkgs  => false,
    distribute  => true,
    project_dir => "~/src/ledej",
  }

  python::requirements { 'reqs-dev':
    requirements => "/Users/${::luser}/src/ledej/reqs/dev.txt",
    virtualenv   => 'venv',
    require      => Package['libjpeg'],
  }

  # python::pip { 'numpy':
  #   ensure     => present,
  #   virtualenv => $python::config::global_venv
  # }
  package { 'numpy':
    ensure => present,
    provider => pip;
  }

  package { 
    'geos':
      ensure => present;
    'gdal':
      ensure => present,
      require => Package['numpy'];
    'rabbitmq':
      ensure => present;
    'libjpeg':
      ensure => present;

    'git-flow':
      ensure => present;  
  }

  package {
    'kicker':
      ensure => present,
      provider => 'gem' 
  }

  nodejs::module { 'sass':
    node_version => 'v0.10'
  }

  boxen::project { 'ledej':
    # dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    source        => 'Ledej/ledej-website',
  }
}
