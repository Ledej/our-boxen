class projects::ledej {
  include redis
  include postgresql
  include elasticsearch
  include python
  include python::virtualenvwrapper

  python::mkvirtualenv{ 'venv':
    ensure      => present,
    systempkgs  => false,
    distribute  => true,
    project_dir => "~/src/ledej",
  }

  python::requirements { 'reqs-dev':
    requirements => '/Users/peteralaoui/src/ledej/reqs/dev.txt',
    virtualenv   => 'venv',
  }

  python::pip { 'numpy':
    ensure     => present,
    virtualenv => $python::config::global_venv
  }

  package { 
    'geos':
      ensure => present;
    'gdal':
      ensure => present;
  }

  boxen::project { 'ledej':
    # dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    source        => 'Ledej/ledej-website',
  }
}
