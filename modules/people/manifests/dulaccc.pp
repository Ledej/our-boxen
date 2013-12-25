class people::dulaccc {
  include alfred
  include chrome
  include dropbox
  include firefox
  include git
  include hub
  # include spotify
  include sublime_text_2

  # include projects::deployment
  include projects::ledej


  $home = "/Users/${::boxen_user}"
  $projects = "${home}/Projects"
  $srcdir = "${boxen::config::srcdir}}"

  file { $srcdir:
    ensure  => directory,
  }
  file { $projects:
    ensure => directory,
  }

  $dotfiles = "${srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'dulaccc/dotfiles',
    require => File[$srcdir],
    notify  => Exec['install-dotfiles'],
  }

  exec { "install-dotfiles":
    cwd         => $dotfiles,
    command     => "make",
    refreshonly => true
  }
}
