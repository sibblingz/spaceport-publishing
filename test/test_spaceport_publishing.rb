require 'helper'

class TestThrowaray < Test::Unit::TestCase
  def test_something_for_real
    flunk "hey buddy, you should probably rename this file and start testing for real"
  end
  
  
  def test_can_call_bundle

    `bin/spaceport bundle --c bundle.config -o app_root -m app_root`

  end
end
