# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fotomoto_origami"
  gem.homepage = "http://github.com/bobmilani/fotomoto_origami"
  gem.license = "MIT"
  gem.summary = %Q{create cards, postcards and other prints for vendors}
  gem.description = %Q{Fotomoto Origami Client for processing cards and postcards}
  gem.email = "bob@fotomoto.com"
  gem.authors = ["Bob Milani"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec


namespace :metrics do
  desc "shows flog complexity metric"
  task :flog do
    puts `find app lib -name \*.rb -printf "%p " | xargs flog -a`
  end

  desc "show flay duplication (copy/paste) metric"
  task :flay do
    puts "Flay " + `find app lib -name \*.rb -printf "%p " | xargs flay`
  end

  desc "run flay and flog"
  task :all => [:flay, :flog] 

end

require 'yard'
YARD::Rake::YardocTask.new
