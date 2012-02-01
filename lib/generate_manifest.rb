#!/usr/bin/env ruby
require 'optparse'


# Daniels Code
if `which md5`==""
 	MD5_COMMMAND = "md5sum"
else
 	MD5_COMMMAND = "md5"
end

def generate_manifest
  

  # bundlePath = ARGV[0]
  # output_dir = ARGV[1]
  options = {}
  opts = OptionParser.new do |opts|
    opts.banner ="Usage: This will create two output files; a manifest.xml, and a full_asset_list.txt"
    opts.on( "-c", "--config CONFIG", "Path to your config file" ) do |path|
      options[:bundle_config_path] = path
    end 
  
    opts.on("-o", "--output OUTPUT", "Directory you would like the two output files to go to") do |path|
      options[:manifest_output_dir] = path
    end
  
  end

  opts.parse!

  bundlePath = options[:bundle_config_path] || spaceport_options[:bundle_config_path]
  output_dir = options[:manifest_output_dir] || spaceport_options[:manifest_output_dir]

  if ( !bundlePath || !output_dir )
    puts opts
    exit
  end

  wants = []
  doNotWants = []
  completeFileList = {}

  File.open(bundlePath, "r") do |f|
  	while !f.eof?
  		line = f.readline
  		matchData = /^\s#(.*)$/.match(line)
  		if matchData
  			next
  		end

  		matchData = /^\s*$/.match(line)
  		if( matchData )
  			next
  		end
		
  		matchData = /^-([^\s]*)/.match(line)
  		if matchData
  			doNotWants.push( {:path => matchData[1]})
  			next;
  		end
		
  		matchData = /^([^\s]*)[\s]*([^\s]*)/.match(line)
  		if( matchData )
  			wants.push( {:path => matchData[1], :version => matchData[2]})
  		end 
			
  	end
  end

  wants.each do |w|
  	Dir.glob( w[:path] ) do |filename|
  		next if File.directory?(filename)

  		completeFileList[filename] = w[:version]
  	end
  end

  doNotWants.each do |d|
  	Dir.glob( d[:path] ) do |filename|
  		next if File.directory?(filename)

  		completeFileList.delete( filename )
  	end
  end

  file_list=completeFileList.keys.sort



  def get_cksum( filename )
  	if MD5_COMMMAND=="md5"
  		`#{MD5_COMMMAND} #{filename} | awk '-F= ' '{ print $2 }'`.strip
  	elsif MD5_COMMMAND=="md5sum"
  		`#{MD5_COMMMAND} #{filename}`.split("  ")[0].strip
  	end
  end

  def get_svn_revision( filename )
   `svn info -- '#{filename}'  | grep "Last Changed Rev" | awk '-F: ' '{ print $2 }'`.strip
  end

  def get_git_revision( filename )
    `git log --format=%h -1 -- #{filename}`.strip 
  end


  def get_version(filename, version_type)


    if ( version_type == 'svn')
      get_svn_revision( filename )
    elsif ( version_type == 'git')
        get_git_revision( filename )
    elsif( version_type=='md5')
        get_cksum( filename )
    else
     raise "version scheme: \"#{version_type}\" specified for filename: \"#{filename}\" is invalid."
    end
  end

  file_list = file_list.map do |filename|
    version = get_version( filename,  completeFileList[filename] )
    if !version || version == ""
      puts "#{filename} is unversioned"
      nil    
    else
      {:version => version, :name => filename, :filesize => File.size( filename ) }
    end
  end.compact

  def get_total_size( file_list )

    total_size = file_list.inject(0){|sum,x|  sum + x[:filesize].to_i}
    puts (total_size / 1024).to_s + " KB" 
    puts (total_size / (1024*1024)).to_s  + " MB" 
    total_size
  end

  def print_size_information( file_list )


    file_extensions ={}
    file_list.each do |a| 
      ext = File.extname( a[:name] ) 
      file_extensions[ ext ] = file_extensions[ ext ] || []
      file_extensions[ext].push(a)
    end

    file_extensions.keys.each do |ext|
      puts ext
      get_total_size( file_extensions[ ext]  )
      puts ""
    end
    puts "Total"
    total_file_size = get_total_size( file_list )/( 1024 * 1024 );
    puts ""
    
    file_sizes_hsh = {}

    file_extensions.keys.each do |ext|
      file_size = get_total_size( file_extensions[ ext]  )/(1024*1024)
      file_sizes_hsh[ ext + "(" + file_size.to_s + "MB)"] = file_size
    end
    
    puts "http://chart.apis.google.com/chart?chs=800x225&cht=p&chd=t:#{file_sizes_hsh.values.join(',')}&chdl=#{file_sizes_hsh.keys.join('|')}&chl=#{file_sizes_hsh.keys.join('|')}&chtt=Disk+Usage(#{total_file_size}+MB)"

  end
  
  


  



  print_size_information( file_list )

  xml_file_list = file_list.map do |value|
    "\t<file " + value.map {|k,v| k.to_s + "=\"#{v}\"" }.join(" ") + "/>"
  end

  prefix = <<-eos
  <?xml version="1.0" encoding="utf-8"?>
  <manifest version="3.02">
  <files>
  eos

  suffix = <<-eos

  </files>
  </manifest>
  eos

  output = prefix + xml_file_list.join("\n") + suffix

  File.open( File.join(output_dir, "manifest.xml"), 'w' ) do |file|
    file.write( output )
  end

  asset_file_name = File.join( output_dir, "full_asset_list.txt" )
  File.open( asset_file_name , 'w' ) do |file|
    file.write( file_list.map{|k| k[:name] }.map do |k| 
      if k[0,2] == "./" 
        k[2, k.length - 1]
      else
        k
      end
    end.join("\n") )
  end
end