class teams::mainstream {
  # Devops™
  include projects::ledej


  # Default dotfiles
  $srcdir = "${boxen::config::srcdir}"
  $dotfiles = "${srcdir}/default-dotfiles"

  repository { $dotfiles:
    source  => 'Ledej/default-dotfiles',
    require => [
      File[$srcdir],
    ],
    notify  => Exec['install-default-dotfiles'],
  }

  exec { "install-default-dotfiles":
    cwd         => $dotfiles,
    command     => "make",
    refreshonly => true
  }
}