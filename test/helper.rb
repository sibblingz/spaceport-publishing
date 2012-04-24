require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

lib_path =  File.join( File.dirname(__FILE__), "../lib" )

require( File.join( lib_path, "lib.rb") ) 
Dir.glob( File.join( lib_path, "**/*.rb" ) ).each do | file |
  require(file)
end

class Test::Unit::TestCase
end
