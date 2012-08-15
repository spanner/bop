source "http://rubygems.org"

# Declare your gem's dependencies in bop.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem 'devise'
gem 'cancan'
gem 'haml'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

group :test, :development do
  gem 'combustion', '~> 0.3.1'
  gem "rspec-rails", "~> 2.0"
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'awesome_print'
end
