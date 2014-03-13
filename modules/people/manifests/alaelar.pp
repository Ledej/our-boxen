class people::alaelar {
  include alfred
  include chrome
  include dropbox
  include firefox
  include git
  include hub
  # include spotify
  include sublime_text_2

  include teams::mainstream


  $home = "/Users/${::boxen_user}"
  $projects = "${home}/Projects"
  $srcdir = "${boxen::config::srcdir}"

  file { $projects:
    ensure => directory,
  }

  ## 
  # Dotfiles

  $dotfiles = "${srcdir}/dotfiles"

  repository { $dotfiles:
    source  => 'alaelar/dotfiles',
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

  # osx::recovery_message { 'Si vous trouvez ce Mac, appelez le 06 67 20 77 93': }

  include osx::dock::autohide
  include osx::finder::show_external_hard_drives_on_desktop
  include osx::finder::unhide_library
  include osx::universal_access::ctrl_mod_zoom
  include osx::disable_app_quarantine
  include osx::no_network_dsstores

  # include osx::global::natural_mouse_scrolling
  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }
}
