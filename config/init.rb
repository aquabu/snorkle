require 'rubygems'
require 'pp'

# bloopsaphone
require 'bloops'


PROJECT_ROOT = File.expand_path(File.dirname(__FILE__)) + "/../"
LIB_ROOT = PROJECT_ROOT + "/lib"
# require all the files in the lib directory
Dir.foreach(LIB_ROOT) {|f| require LIB_ROOT + "/" + f unless [".",".."].include?(f)}
