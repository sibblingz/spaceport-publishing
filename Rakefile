
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


task :ocra do 
  `ocra --gemfile Gemfile --gem-full --output spaceport-publishing.exe bin/spaceport`
end

task :default => :test

# require 'releasy'
# Releasy::Project.new do
#   name "Spaceport"
#   version "0.0.1"
#   
#   executable "bin/spaceport"
#   files "lib/**/*rb"
#   
#   #dont include japanese characters...
#   exclude_encoding
#   
#   add_build :osx_app do
#     url "com.spaceport.bundling"
#     wrapper "media/gosu-mac-wrapper-0.7.41.tar.gz"
#   end
#   
#   
#   add_build :windows_standalone do
#     add_package :zip
#   end
#   #  add_build :windows_wrapped do
#   #   exclude_tcl_tk # Assuming application doesn't use Tcl/Tk, then it can save a lot of size by using this.
#   #   add_package :zip
#   # end
# end