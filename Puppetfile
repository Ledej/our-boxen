# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.3.8"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",     "1.0.1"
github "foreman",     "1.1.0"
github "gcc",         "2.0.1"
github "git",         "1.3.7.1", :repo => "Ledej/puppet-git"
github "go",          "2.0.1"
github "homebrew",    "1.6.1"
github "hub",         "1.3.0"
github "inifile",     "1.0.1", :repo => "puppetlabs/puppetlabs-inifile"
github "module-data", "0.0.1", :repo => "ripienaar/puppet-module-data"
github "nginx",       "1.4.3"
github "nodejs",      "3.5.0"
github "openssl",     "1.0.0"
github "phantomjs",   "2.1.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "ruby",        "7.1.6"
github "stdlib",      "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",     "1.1.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

github "osx",             "2.2.1"
github "redis",           "2.1.0"
github "dropbox",         "1.2.0"
github "hipchat",         "1.1.0"
github "sysctl",          "1.0.0"
github "postgresql",      "2.2.2"
github "memcached",       "1.4.0" #, :repo => "Ledej/puppet-memcached"
github "java",            "1.1.2"
github "elasticsearch",   "2.1.0"
github "alfred",          "1.1.7"
github "heroku",          "2.1.1"
github "firefox",         "1.1.5"
github "chrome",          "1.1.2"
github "vlc",             "1.0.5"
github "cyberduck",       "1.0.1"
github "appcleaner",      "1.0.0"
github "python",          "1.3.0" #, :repo => "Ledej/puppet-python"
github "sublime_text_2",  "1.1.2"
