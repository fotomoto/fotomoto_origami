source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem 'httparty'
# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rspec"
  gem "yard"
  gem "bundler"
  gem "jeweler"
  gem "reek"
  gem "roodi"
  gem "guard"
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'libnotify' if /linux/ =~ RUBY_PLATFORM
  gem 'growl' if /darwin/ =~ RUBY_PLATFORM
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'simplecov', :require => false
  gem 'flay'
  gem 'flog'
end
