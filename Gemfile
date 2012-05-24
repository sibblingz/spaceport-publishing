source :rubygems
gem "OptionParser"
gem "json"
group :development do
  gem "bundler", :platform => "ruby" 

 #:platform => "ruby" is code for NOT windows ( http://gembundler.com/man/gemfile.5.html )
 
	#I can't seem to build jeweler on windows, because I can't manage to build libxml-ruby, which one of these two depends on
 # because we don't use these on windows anyway ( we dont make a gem ) it does not matter
  gem "jeweler", :platform => "ruby"
end
