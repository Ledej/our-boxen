class people::dulaccc {
  include alfred
  include chrome
  include dropbox
  include firefox
  include git
  include hub
  # include spotify
  include sublime_text_2

  include teams::mainstream

  include projects::ledej


  $home = "/Users/${::boxen_user}"
  $projects = "${home}/Projects"
  $srcdir = "${boxen::config::srcdir}"

  file { $projects:
    ensure => directory,
  }

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
}
