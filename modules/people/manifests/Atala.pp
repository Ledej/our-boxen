class people::atala {
  include teams::mainstream

  include alfred
  include git


  $home = "/Users/${::boxen_user}"
  $srcdir = "${boxen::config::srcdir}"


  ## 
  # Dotfiles

  $dotfiles = "${srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'Atala/dotfiles',
    require => [
      File[$srcdir],
      Exec["install-default-dotfiles"],
    ],
    notify  => Exec['install-dotfiles'],
  }

  exec { "install-dotfiles":
    cwd         => $dotfiles,
    command     => "make",
    refreshonly => true
  }

  # override the git global config
  Git::Config::Global <| title == 'core.excludesfile' |> {
    value   => "~/.gitignore_global",
    require => Exec["install-dotfiles"]
  }


  ##
  # OSX preferences

  Boxen::Osx_defaults {
    user => $::boxen_user,
  }

  include osx::dock::autohide
  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }
}
