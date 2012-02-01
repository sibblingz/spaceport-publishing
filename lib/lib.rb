require 'json'

def get_spaceport_options
  if File.exists?(".spaceport")
    opts = JSON.parse( File.open( ".spaceport", "r" ).read )
    
    out = {}
    opts.each do |k,v|
      out[k] = v
      out[k.intern] = v
    end
    return out
  else
    return {}
  end
end

def spaceport_options()
  get_spaceport_options()
end