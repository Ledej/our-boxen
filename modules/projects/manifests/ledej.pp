class projects::ledej {
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
      Package['boxen/brews/python'],
      Repository[$project_dir],
    ],
    ensure      => present,
  }

  # python::requirements { 'reqs-dev':
  #   requirements => "${project_dir}/reqs/dev.txt",
  #   # upgrade      => true,
  #   virtualenv   => $venv_name,
  #   require      => [
  #     Package['jpeg'],
  #     Package['libmemcached'],
  #     Repository[$project_dir],
  #   ]
  # }

  python::pip { 'numpy':
    ensure     => present,
    virtualenv => $python::config::global_venv,
    require    => Package['boxen/brews/python'],
  }

  # Homebrew packages
  package { 'gdal':
    ensure  => present,
    require => Exec['pip_install_numpy'],
  }
  package {
    [
      'jpeg',
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

  # Node packages
  # nodejs::module { 'sass':
  #   node_version => hiera('nodejs::global::version')
  # }

  # Project
  boxen::project { $project_name:
    # dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    source        => 'Ledej/ledej-website',
    require       => [
      Package['jpeg'],
      Package['git-flow'],
      Package['boxen/brews/python'],
      Service['postgresql'],
    ], 
  }
}