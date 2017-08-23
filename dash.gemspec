# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dash/version"

Gem::Specification.new do |spec|
  spec.name          = "dash"
  spec.version       = Dash::VERSION
  spec.authors       = ["danlewis"]
  spec.email         = ["webmaster@adventistmedia.org.au"]

  spec.summary       = %q{A bootstrap dashboard theme for Adventist dashboards }
  spec.description   = %q{A bootstrap dashboard theme for Adventist dashboards }
  spec.homepage      = "http://adventistmedia.org.au"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bootstrap", "~> 4.0.0.beta"
  spec.add_dependency "browser"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
