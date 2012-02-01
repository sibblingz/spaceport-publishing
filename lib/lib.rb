puts "ASdasdasd"
require 'json'

def get_spaceport_options
  if File.exists?(".spaceport")
    return JSON.parse( File.open( ".spaceport", "r" ).read )
  else
    return {}
  end
end

spaceport_options = get_spaceport_options()
