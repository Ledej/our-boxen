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

  # extra
  include chrome
  include firefox
  include hipchat
  include dropbox
  include cyberduck

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
      # Package['boxen/brews/libmemcached'],
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
      # 'redis',
    ]:
    ensure => present,
  }

  # Gem packages
  ruby::gem { 'kicker for ${ruby::global::version}':
    gem     => 'kicker',
    ruby    => ruby::global::version,
    version => '~> 3.0.0',
    ensure  => present,
  }
  ruby::gem { 'foreman for ${ruby::global::version}':
    gem     => 'foreman',
    ruby    => ruby::global::version,
    version => '~> 0.63.0',
    ensure  => present,
  }
  ruby::gem { 'sass for ${ruby::global::version}':
    gem     => 'sass',
    ruby    => ruby::global::version,
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
  # package {
  #   [
  #     'virtualenv',
  #     'virtualenvwrapper',
  #   ]:
  #   require => Package['python'],
  #   ensure => present,
  #   provider => pip,
  # }

  ##
  # Git flow 

  # exec { "git-flow init":
  #   cwd       => $project_dir,
  #   command   => "git flow init -d",
  #   require   => [
  #     Package['boxen/brews/git'],
  #     Package['git-flow'],
  #     Repository[$project_dir],
  #   ],
  # }

  # git::config::local { "git-flow config branch master":
  #   repo  => $project_dir,
  #   key   => "gitflow.branch.master",
  #   value => "master",
  #   require => Exec["git-flow init"],
  # }

  # git::config::local { "git-flow config branch develop":
  #   repo  => $project_dir,
  #   key   => "gitflow.branch.develop",
  #   value => "develop",
  #   require => Exec["git-flow init"],
  # }

  ## 
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
