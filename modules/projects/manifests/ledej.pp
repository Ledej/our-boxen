class projects::ledej {
  include dnsmasq
  include git
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
      # 'redis',
    ]:
    ensure => present,
  }

  # Default Ruby version
  class { 'ruby::global': version => '1.9.3' }

  # Gem packages
  $ruby_version = "1.9.3"
  ruby::gem { 'kicker for ${ruby_version}':
    gem     => 'kicker',
    ruby    => $ruby_version,
    version => '~> 3.0.0',
    ensure  => present,
  }
  ruby::gem { 'foreman for ${ruby_version}':
    gem     => 'foreman',
    ruby    => $ruby_version,
    version => '~> 0.63.0',
    ensure  => present,
  }
  ruby::gem { 'sass for ${ruby_version}':
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

  ##
  # Git flow 

  exec { "git-flow init":
    cwd       => $project_dir,
    command   => "git flow init -d",
    require   => [
      Package['boxen/brews/git'],
      Repository[$project_dir],
    ],
  }

  git::config::local { "git-flow config branch master":
    repo  => $project_dir,
    key   => "gitflow.branch.master",
    value => "master",
    require => Exec["git-flow init"],
  }

  git::config::local { "git-flow config branch develop":
    repo  => $project_dir,
    key   => "gitflow.branch.develop",
    value => "develop",
    require => Exec["git-flow init"],
  }

  ## 
  # Project

  boxen::project { $project_name:
    # dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    # python        => '2.7.4',
    source        => 'Ledej/ledej-website',
    require       => [
      Package['libjpeg'],
      Package['git-flow'],
      Service['postgresql'],
    ], 
  }
}
