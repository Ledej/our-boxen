class people::415bruno {
  include teams::mainstream
  
  include alfred
  include git


  $home = "/Users/${::boxen_user}"
  $srcdir = "${boxen::config::srcdir}"


  ##
  # OSX preferences
  
  Boxen::Osx_defaults {
    user => $::boxen_user,
  }

  include osx::dock::autohide
  include osx::global::natural_mouse_scrolling
}
