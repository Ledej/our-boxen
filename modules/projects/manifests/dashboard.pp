class projects::dashboard {
  include git
  include heroku
  include ruby
  include nodejs

  $project_name = 'ledej-dashboard'
  $project_dir = "${boxen::config::srcdir}/${project_name}"

  # Ruby
  $ruby_version = hiera('ruby::global::version')
  ruby::local { $project_dir:
    version => $ruby_version
  }

  # Gem packages
  ruby::gem { "compass for ${ruby_version}":
    gem     => 'compass',
    ruby    => $ruby_version,
    version => '~> 0.12.5',
    ensure  => present,
  }

  # Node packages
  $nodejs_version = hiera('nodejs::global::version')
  nodejs::module { 'yo':
    node_version => $nodejs_version
  }
}