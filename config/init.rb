require 'rubygems'
require 'pp'

# bloopsaphone
require 'bloops'

# Project paths
PROJECT_ROOT = File.expand_path(File.dirname(__FILE__)) + "/../"
LIB_RUBY_ROOT = PROJECT_ROOT + "/lib/ruby"
LILYPOND_PATH = "/Applications/LilyPond.app/Contents/Resources/bin/lilypond" # this is the OSX default location

# Load included libraries
# require all the files in the lib ruby directory
Dir.foreach(LIB_RUBY_ROOT) {|f| require LIB_RUBY_ROOT + "/" + f unless [".",".."].include?(f)}

# load chuckr
require PROJECT_ROOT + "/lib/submodules/chuckr/lib/chuckr.rb"
