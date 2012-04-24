#!/usr/bin/env ruby

require 'optparse'

def bundle
  # bundlePath = ARGV[0]
  # output_dir = ARGV[1]
  options = {}
  opts = OptionParser.new do |opts|
    opts.banner ="Usage: "
    opts.on( "-c", "--config CONFIG", "Path to your config file" ) do |path|
      options[:bundle_config_path] = path
    end 

    opts.on("-o", "--output BUNDLE_DIR", "Directory you would like bundle to go to") do |path|
      options[:bundle_dir] = path
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
  bundle_dir = options[:bundle_dir] ||  spaceport_options[:bundle_dir]
  app_root_dir = options[:application_root] || spaceport_options[:application_root] 
  manifest_output_dir = options[:manifest_output_dir] || spaceport_options[:manifest_output_dir] || app_root_dir

  if ( !bundle_dir || !app_root_dir || !manifest_output_dir || !bundle_config_path)  
    puts opts
    exit
  end


  current_dir = File.expand_path(File.dirname(__FILE__))
  built_client_dir = File.join(bundle_dir, "built_client", "assets")
  manifest_generating_script_path = File.join(current_dir, "generate_manifest.rb")
  full_asset_list_path = File.join(manifest_output_dir, "full_asset_list.txt")
  manifest_path = File.join(manifest_output_dir, "manifest.xml")

  if ( !options[:no_manifest] )
    puts "spaceport generate_manifest --config #{bundle_config_path} -a #{app_root_dir} --output #{manifest_output_dir}"
    puts `spaceport generate_manifest --config #{bundle_config_path} -a #{app_root_dir} --output #{manifest_output_dir}`
  end
  `rm -rf #{built_client_dir}`
  `mkdir -p #{built_client_dir}`

  `rsync -rvmL --exclude='#{built_client_dir}/*' --include-from=#{full_asset_list_path} --include='*/'  --exclude='*' #{manifest_output_dir}/ #{built_client_dir}`
  `cp #{manifest_path} #{built_client_dir}`

  # TODO:
  # Zip stuff up for Android

  #( cd built_client && zip -r built_client.zip *.js content *.html manifest.xml )
  #cp built_client/built_client.zip $DESTINATION 
  #echo "copying built_client.zip to $DESTINATION"
end