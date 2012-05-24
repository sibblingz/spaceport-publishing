require 'helper'

require 'fileutils'

class TestThrowaray < Test::Unit::TestCase
  
  
  def setup
    FileUtils.mkdir_p('tmp')
    FileUtils.cp_r( 'test/assets', 'tmp' )
  end
  
  def teardown
    FileUtils.rm_r('tmp')
  end
  
  def test_something_for_real
    #flunk "hey buddy, you should probably rename this file and start testing for real"
  end
  
  
  def test_can_call_bundle_with_invalid_bundle
    #`bin/spaceport bundle --c bundle.config -o app_root -m app_root`
  end
  
  def test_can_bundle
    path = "tmp/assets/test_app_1"    
    app_root = "."
    bundle_config = File.join( path, "bundle.config" )
    
    puts "bin/spaceport bundle --c #{bundle_config}"
    puts `bin/spaceport bundle --c #{bundle_config}`
    
    assert( File.exists?( File.join( path, "built_client", "assets" ) ) )
    
    assert( File.exists?( File.join( path, "built_client", "assets", "human_male.png" ) ) )
    assert( File.exists?( File.join( path, "built_client", "assets", "human_female.png" ) ) )
    assert( File.exists?( File.join( path, "built_client", "assets", "goodfolder", "1.js" ) ) )
    assert( File.exists?( File.join( path, "built_client", "assets", "goodfolder", "1.js" ) ) )
    assert( !File.exists?( File.join( path, "built_client", "assets", "badfolder" ) ) )
    
    assert( File.exists?( File.join( path, "built_client", "assets", "manifest.xml" ) ) )
    
    assert( !File.exists?( File.join( path, "built_client", "assets", "goodfolder", "badsubfolder" ) ) )
  end
end
