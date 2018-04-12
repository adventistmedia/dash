$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dash/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "dash"
  s.version       = Dash::VERSION
  s.authors       = ["danlewis"]
  s.email         = ["webmaster@adventistmedia.org.au"]
  s.summary       = %q{A dashboard for Adventist apps }
  s.description   = %q{A dashboard for Adventist apps }
  s.homepage      = "http://adventistmedia.org.au"
  s.license       = "MIT"

  s.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
  # UI
  s.add_dependency "bootstrap", "4.0.0.beta"
  s.add_dependency "kaminari", "~> 1.1.1"
  s.add_dependency "simple_form", "~> 4.0.0"
  s.add_dependency "record_tag_helper", "~> 1.0"
  # Email and Notifications
  s.add_dependency "slack-notifier", "~> 2.3"
  s.add_dependency "mandrill_dm", "~> 1.3.4"
  # Authentication and Authorization
  s.add_dependency "cancancan", "~> 2.1.2"
  s.add_dependency "worldly", "~> 1.0.2"
  # Auditing
  s.add_dependency "audited", "4.7.1"

  # File Management
  s.add_dependency  "carrierwave", "~> 1.2.0"

  s.add_dependency "faraday", "~> 0.13.1"

  # Development
  s.add_development_dependency "sqlite3"

end
