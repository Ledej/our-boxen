class ledej::environment {
  include osx
  include ledej::apps::mac

  # OS X stuffs
  osx::recovery_message { 'Si vous trouvez ce Mac, appelez le 06 67 20 77 93': }
  include osx::finder::show_external_hard_drives_on_desktop
  include osx::finder::unhide_library
  include osx::universal_access::ctrl_mod_zoom
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
}