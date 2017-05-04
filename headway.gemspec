$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "headway/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "headway"
  s.version     = Headway::VERSION
  s.authors     = ["rubiii"]
  s.email       = ["me@rubiii.com"]
  s.homepage    = "http://example.com"
  s.summary     = "Summary of Headway."
  s.description = "Description of Headway."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7.1"
  s.add_dependency "pg"
  s.add_dependency "hamlit-rails"
  s.add_dependency "font-awesome-rails"
  s.add_dependency "request_store"
  s.add_dependency "sucker_punch"

  s.add_development_dependency "bundler", "~> 1.14"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
