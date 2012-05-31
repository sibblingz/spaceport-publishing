Installation
===========
As a 3rd party developer, just  "sudo gem install sp"

What it Do
==========
spaceport publishing currently  has two features
1) generate_manifest
	generate_manifest takes a bundle.config file as input.  It parses through the list of files in the bundle.config, and creates a correctly formatted manifest.xml file; with the list of files; file hashes; and the list of plugins.

2) bundle
	Bundle takes a bundle.config; generates a manifest; and then takes all the files in the manifest and puts them in a folder called built_client/assets.

spaceport bundle --c [path to bundle config]

For documentation on how to call the various methods; and on how to create a proper bundle.config file, please take a look at the bundle.config in the tests folder.

Usage
=====
spaceport bundle --c [path to bundle config]
spaceport generate_manifest --c [path to bundle config]

Development
===========

If you would like to actually modify this plugin
To build ( and install ) run these commands:
  sudo gem install bundle
	bundle install
	rake build
	sudo rake install




Building for Windows
====================
God help you.  Give up now. 

These are instructions if you ever need to build the spaceport publishing executable
First download ruby for windows:
http://rubyinstaller.org/
Then download the ruby devkit.  This is for building gems that have a native component ( like the json gem ):
http://rubyinstaller.org/add-ons/devkit/

Then do this.  You must do this on a windows machine:
gem install ocra
remove entire development section from gemfile
ocra --add-all-core --gemfile Gemfile --gem-full --output spaceport-publishing.exe bin/spaceport


Tests
=====
To run the tests: 
rake test