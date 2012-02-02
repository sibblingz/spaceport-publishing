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
  
    opts.on("--no-manifest" "Do not generate a manifest or fuller_asset_list") do |value|
      options[:no_manifest] = true
    end
  end

  opts.parse!

  bundle_config_path = options[:bundle_config_path] || spaceport_options[:bundle_config_path]
  bundle_dir = options[:bundle_dir] ||  spaceport_options[:bundle_dir]
  manifest_output_dir = options[:manifest_output_dir] || spaceport_options[:manifest_output_dir]

  if ( !bundle_dir || !manifest_output_dir || !bundle_config_path)  
    bundle_config_path = ARGV[0]
    manifest_output_dir = ARGV[1]
    bundle_dir = ARGV[2]
    puts "You are using this in the deprecated way! Please do not"
    exit
  end


  current_dir = File.expand_path(File.dirname(__FILE__))
  built_client_dir = File.join(bundle_dir, "assets")
  manifest_generating_script_path = File.join(current_dir, "generate_manifest.rb")
  full_asset_list_path = File.join(manifest_output_dir, "full_asset_list.txt")
  manifest_path = File.join(manifest_output_dir, "manifest.xml")

  if ( !options[:no_manifest] )
    puts `spaceport generate_manifest --config #{bundle_config_path} --output #{manifest_output_dir}`
  end
  `rm -rf #{built_client_dir}`
  `mkdir -p #{built_client_dir}`

  `rsync -rvmL --exclude='#{built_client_dir}/*' --include-from=#{full_asset_list_path}  --exclude='*.*' #{manifest_output_dir}/ #{built_client_dir}`
  `cp #{manifest_path} #{built_client_dir}`

  # TODO:
  # Zip stuff up for Android

  #( cd built_client && zip -r built_client.zip *.js content *.html manifest.xml )
  #cp built_client/built_client.zip $DESTINATION 
  #echo "copying built_client.zip to $DESTINATION"
end