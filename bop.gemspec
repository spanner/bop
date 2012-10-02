$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bop/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bop"
  s.version     = Bop::VERSION
  s.authors     = ["William Ross"]
  s.email       = ["will@spanner.org"]
  s.homepage    = "http://bop.spanner.org"
  s.summary     = "HTML5 CMS engine for Rails 3.2+"
  s.description = "Blocks on Pages. Very simple, very lovely html5 CMS designed from the ground up as a rails engine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md", "LICENSE"]

  s.add_dependency "rails", '~> 3.2.0'

  s.add_dependency 'ancestry'
  s.add_dependency 'liquid'
  # s.add_dependency 'radius'
  s.add_dependency 'redcarpet'
  s.add_dependency 'paperclip'
  s.add_dependency 'coffeebeans'
  s.add_dependency 'haml_coffee_assets'

  s.add_development_dependency "sqlite3"
end
