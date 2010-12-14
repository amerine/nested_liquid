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
  gem.name = "nested_liquid"
  gem.homepage = "http://github.com/amerine/nested_liquid"
  gem.license = "MIT"
  gem.summary = "Bypass liquids saniziation and render nested liquid templates"
  gem.description = "Bypass liquids saniziation and render nested liquid templates inside certian namespaces"
  gem.email = "mark@amerine.net"
  gem.authors = ["Mark Turner"]
  #gem.add_runtime_dependency 'liquid', '> 2.0.0'
  #gem.add_runtime_dependency 'activesupport', '> 2.3.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |spec|
  spec.libs << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
