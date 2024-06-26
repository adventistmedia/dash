$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dash/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "dash"
  s.version       = Dash::VERSION
  s.authors       = ["adventistmedia"]
  s.email         = ["webmaster@adventistmedia.org.au"]
  s.summary       = %q{A dashboard for Adventist apps }
  s.description   = %q{A dashboard for Adventist apps }
  s.homepage      = "http://adventistmedia.org.au"
  s.license       = "MIT"

  s.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.2.1.1"
  # UI
  s.add_dependency "bootstrap", "4.3.1"
  s.add_dependency "kaminari", "~> 1.2.1"
  s.add_dependency "simple_form", "~> 5.0"
  #s.add_dependency "record_tag_helper", "~> 1.0" added as helper manually as they haven't released a new version to support Rails 6
  # Email and Notifications
  s.add_dependency "mandrill_dm", "~> 1.3.4"
  # Address
  s.add_dependency "worldly", "~> 1.0.2"
  # Auditing
  s.add_dependency "audited", "5.3.3"

  # File Management
  s.add_dependency  "carrierwave", "~> 2.0"
# faraday gem is a pain in that many other gems that use is require very specific versions.
# Be flexiable and don't require version
  s.add_dependency "faraday"#, "~> 0.14.0"

  # Development
  s.add_development_dependency "sqlite3"

end
