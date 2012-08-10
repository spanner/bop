$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bop/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bop"
  s.version     = Bop::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Bop."
  s.description = "TODO: Description of Bop."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", '~> 3.2.0'
  # s.add_dependency "jquery-rails"

  s.add_dependency 'ancestry'
  s.add_dependency 'liquid'
  # s.add_dependency 'radius'
  s.add_dependency 'redcarpet'

  s.add_development_dependency "sqlite3"
end
