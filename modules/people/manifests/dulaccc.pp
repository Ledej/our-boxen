class people::dulaccc {
  include alfred
  include chrome
  include dropbox
  include firefox
  include git
  include hub
  include spotify
  include sublime_text_2

  # include projects::deployment
  include projects::ledej


  $home = "/Users/${::luser}"
  $projects = "${home}/Projects"

  file { $projects:
    ensure => directory,
  }
}
