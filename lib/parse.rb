def parse( bundlePath )
  
  wants = []
  doNotWants = []
  plugins = []
  app_root_dir = nil
  output_dir = nil

  parserState = nil

  File.open(bundlePath, "r") do |f|
  	while !f.eof?
  	  
  	  #parse files section
  	  
  		line = f.readline
  		matchData = /^\s#(.*)$/.match(line)
  		if matchData
  			next
  		end

  		matchData = /^\s*$/.match(line)
  		if( matchData )
  			next
  		end

      
  	  matchData = line.match( /^\s*APP_ROOT:\s*(.*)$/)
      if (matchData )
        puts "APP DIR" + matchData[1]
        app_root_dir = matchData[1]        
        parserState = nil
        next
      end
      
      matchData = line.match( /^\s*OUTPUT_DIR:\s*(.*)$/)
      if (matchData )
        puts "OUTPUT_DIR" + matchData[1]
        output_dir = matchData[1]
        parserState = nil
        next
      end
      
      matchData = line.match( /^\s*PLUGINS:\s*$/)
      if (matchData )
        puts "PLUGINS"
        parserState = "PLUGINS"
        next
      end

      matchData = line.match( /^\s*FILES:\s*$/)
      if (matchData )
        puts "FILES"
        parserState = "FILES"
        next
      end

      if parserState == "FILES"
    		matchData = /^-([^\s]*)/.match(line.dup.strip!)
    		if matchData
    			doNotWants.push( {:path => matchData[1]})
    			next;
    		end
		
    		matchData = /^(\S*)[\s]*(\S*)/.match(line.strip!)
    		if( matchData )
    			wants.push( {:path => matchData[1], :version => matchData[2]})
    		end 
			end
			
			if parserState == "PLUGINS"
			  
			  matchData = /^([^\s]*)[\s]*([^\s]*)/.match(line.strip!)
			  plugins.push( { :id => matchData[1], :version => matchData[2] } )
		  end
  	end
  end
  
  { wants: wants, doNotWants: doNotWants, plugins: plugins, app_root_dir: app_root_dir, output_dir: output_dir }

end