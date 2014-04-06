class people::dulaccc {
  include teams::mainstream

  include alfred
  include git


  $home = "/Users/${::boxen_user}"
  $srcdir = "${boxen::config::srcdir}"


  ## 
  # Dotfiles

  $dotfiles = "${srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'dulaccc/dotfiles',
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
  include osx::global::natural_mouse_scrolling
  # class { 'osx::global::natural_mouse_scrolling':
  #   enabled => false
  # }
  include osx::global::disable_autocorrect
  include osx::finder::enable_quicklook_text_selection
}
