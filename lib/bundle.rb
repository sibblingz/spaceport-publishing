#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'
def bundle
  # bundlePath = ARGV[0]
  # output_dir = ARGV[1]
  options = {}
  opts = OptionParser.new do |opts|
    opts.banner ="Usage: "
    opts.on( "-c", "--config CONFIG", "Path to your config file" ) do |path|
      options[:bundle_config_path] = path
    end 

    opts.on("-o", "--output OUTPUT_DIR", "Directory you would like bundle to go to") do |path|
      options[:output_dir] = path
    end
  
    opts.on("-m", "--manifest MANIFEST_DIR", "Directory you would like the manifest to go to") do |path|
      options[:manifest_output_dir] = path
    end
    
    opts.on("-a", "--app_root APPLICATION_ROOT", "Directory that is the root of your application server") do |path|
      options[:application_root] = path
    end
  
  
    opts.on("--no-manifest" "Do not generate a manifest or fuller_asset_list") do |value|
      options[:no_manifest] = true
    end
  end

  opts.parse!



  bundle_config_path = options[:bundle_config_path] || spaceport_options[:bundle_config_path]
  parsedResults = parse( bundle_config_path )
  
  


  app_root_dir =  options[:application_root] || parsedResults[:app_root_dir]
  output_dir = options[:output_dir] || parsedResults[:output_dir] 

  #everything is relative to location of bundle file
  root_dir = File.dirname( bundle_config_path )  
  app_root_dir = File.join( root_dir, app_root_dir )
  output_dir = File.join( root_dir, output_dir )

  #manifest_output_dir = options[:manifest_output_dir]  || output_dir




  if ( !output_dir || !app_root_dir || !bundle_config_path)  
    puts opts
    exit
  end

  built_client_dir = File.join(output_dir, "built_client", "assets")
  full_asset_list_path = File.join(built_client_dir, "full_asset_list.txt")

  FileUtils.rm_rf( built_client_dir )
  FileUtils.mkdir_p( built_client_dir )

  if ( !options[:no_manifest] )
    puts "spaceport generate_manifest --config #{bundle_config_path} -a #{app_root_dir} --output #{output_dir}"
    puts `#{SPACEPORT_BIN_PATH} generate_manifest --config #{bundle_config_path} -a #{app_root_dir} --output #{built_client_dir}`
  end

  File.open( full_asset_list_path ) do |file|
    file.each do |line|
      line.strip!
      dir = File.join(  built_client_dir, File.dirname( line ) )
      FileUtils.mkdir_p( dir )
      FileUtils.cp( File.join( File.expand_path(app_root_dir), line ), File.join( dir, File.basename(line) ) )
    end
  end

  # TODO:
  # Zip stuff up for Android

  #( cd built_client && zip -r built_client.zip *.js content *.html manifest.xml )
  #cp built_client/built_client.zip $DESTINATION 
  #echo "copying built_client.zip to $DESTINATION"
end