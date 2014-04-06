class projects::ledej {
  include dnsmasq
  include git
  include heroku
  include redis
  include postgresql
  include elasticsearch
  # include memcached::lib
  include python
  include python::virtualenvwrapper
  include ruby
  include nodejs

  $project_name = 'ledej'
  $project_dir = "${boxen::config::srcdir}/${project_name}"
  $venv_name = 'ledej'

  python::mkvirtualenv{ $venv_name:
    systempkgs  => false,
    distribute  => true,
    project_dir => $project_dir,
    require     => [
      Package['python'],
      Repository[$project_dir],
    ],
    ensure      => present,
  }

  python::requirements { 'reqs-dev':
    requirements => "${project_dir}/reqs/dev.txt",
    virtualenv   => $venv_name,
    require      => [
      Package['libjpeg'],
      Package['libmemcached'],
      Repository[$project_dir],
    ]
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
      'libmemcached',
    ]:
    ensure => present,
  }

  # Ruby
  $ruby_version = hiera('ruby::global::version')

  # Gem packages
  ruby::gem { "kicker for ${ruby_version}":
    gem     => 'kicker',
    ruby    => $ruby_version,
    version => '~> 3.0.0',
    ensure  => present,
  }
  ruby::gem { "foreman for ${ruby_version}":
    gem     => 'foreman',
    ruby    => $ruby_version,
    version => '~> 0.63.0',
    ensure  => present,
  }
  ruby::gem { "sass for ${ruby_version}":
    gem     => 'sass',
    ruby    => $ruby_version,
    version => '~> 3.2.13',
    ensure  => present,
  }

  # Default NodeJS version
  include nodejs::v0_10
  class { 'nodejs::global': version => 'v0.10' }

  # Node packages
  # nodejs::module { 'sass':
  #   node_version => 'v0.10'
  # }

  # Python packages
  package { 'numpy':
    require => Package['python'],
    ensure => present,
    provider => pip,
  }

  # Project
  boxen::project { $project_name:
    # dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    source        => 'Ledej/ledej-website',
    require       => [
      Package['libjpeg'],
      Package['git-flow'],
      Package['python'],
      Service['postgresql'],
    ], 
  }
}