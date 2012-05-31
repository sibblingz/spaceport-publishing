#!/usr/bin/env ruby
require 'optparse'
require 'digest'

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
      options[:output_dir] = path
    end
    
    opts.on("-a", "--app_root APPLICATION_ROOT", "Directory that is the root of your application server") do |path|
      options[:application_root] = path
    end
  
  end

  opts.parse!

  bundlePath = options[:bundle_config_path]
  app_root_dir = options[:application_root]
  output_dir = options[:output_dir]

  if ( !bundlePath  )
    puts "please specify a bundle.config"
    puts opts
    exit
  end

  completeFileList = {}
  
  parsedResults = parse( bundlePath )
  
  
  wants = parsedResults[:wants]
  doNotWants = parsedResults[:doNotWants]
  plugins = parsedResults[:plugins]
  app_root_dir = app_root_dir || File.join( File.dirname(bundlePath), parsedResults[:app_root_dir] )
  output_dir = output_dir || parsedResults[:output_dir]
  

  
  if (!app_root_dir || !output_dir  )
    puts "please specify an APP_ROOT and OUTPUT_DIR"
    puts opts
    exit
  end
  
  original_dir = Dir.pwd
  Dir.chdir(  app_root_dir )

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
    Digest::MD5.file( filename )
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
    #Always use md5
    version = get_cksum( filename )
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
  

  def generate_manifest_3_3( file_list, plugins )
    prefix = <<-eos
<?xml version="1.0" encoding="utf-8"?>
<manifest version="THIS_DOES_NOTHING" platform="3.3">
    eos
    
    plugins = "<plugins>\n" + plugins.map do |plugin|
      "\t<entry id=\"#{plugin[:id]}\" version=\"#{plugin[:version]}\"/>"
    end.join("\n") + "\n</plugins>\n"

    
    xml_file_list = file_list.map do |_value|
      value = _value.dup
      value[:id] = value[:name]
      value.delete(:name)
      "\t<entry " + value.map {|k,v| k.to_s + "=\"#{v}\"" }.join(" ") + "/>"
    end
    
    startup = <<-eos
<startup>
#{xml_file_list.join("\n")}
</startup>
eos
    
    suffix = <<-eos
<code></code>
<assets></assets>
</manifest>
eos
    
    output = prefix + plugins + startup + suffix
  end

  def generate_manifest_3_02( file_list )
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
    output
  end

  print_size_information( file_list )
  
  output = generate_manifest_3_3( file_list, plugins )


  Dir.chdir( original_dir )
  
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

