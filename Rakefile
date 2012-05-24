
require 'rubygems'
require 'bundler'


begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "sp"
  gem.homepage = "http://github.com/sibblingz/spaceport-publisher"
  gem.license = "ALL OF THEM"
  gem.summary = %Q{Bundling tool for spaceport}
  gem.description = %Q{Seriously, this thing is great}
  gem.email = "daniel@sibblingz.com"
  gem.authors = ["djacobs7"]
  gem.version = "3.4"
  
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
# 
# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
#   test.rcov_opts << '--exclude "gems/*"'
# end



task :default => :test
# 
# #only valid on os x
# require 'releasy'
# Releasy::Project.new do
#   name "Spaceport-Publishing"
#   version "0.0.1"
#   
#   executable "bin/spaceport"
#   files "lib/**/*rb"
#   
#   #dont include japanese characters...
#   exclude_encoding
#   
#   add_build :osx_app do
#     url "com.spaceport.publishing"
#     wrapper "media/gosu-mac-wrapper-0.7.41.tar.gz"
#     add_package :dmg
#   end
#   
# end