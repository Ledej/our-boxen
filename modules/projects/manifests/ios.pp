class projects::ios {
  include git
  include ruby

  $project_name = 'ledej-ios'
  $project_dir = "${boxen::config::srcdir}/${project_name}"

  # Ruby
  $ruby_version = hiera('ruby::global::version')
  ruby::local { $project_dir:
    version => $ruby_version,
    require => Repository[$project_dir],
  }

  # Gem packages
  ruby::gem { "cocoapods for ${ruby_version}":
    gem     => 'cocoapods',
    ruby    => $ruby_version,
    version => '~> 0.33.1',
    ensure  => present,
  }
  ruby::gem { "xcpretty for ${ruby_version}":
    gem     => 'xcpretty',
    ruby    => $ruby_version,
    version => '~> 0.1.5',
    ensure  => present,
  }

  # Debug tools
  package {
    [
      'chisel',
    ]:
    ensure => present,
  }

  repository { $project_dir:
    source => "Ledej/${project_name}"
  }
}