require 'rubygems'
require 'pp'

# bloopsaphone
require 'bloops'


PROJECT_ROOT = File.expand_path(File.dirname(__FILE__)) + "/../"
LIB_RUBY_ROOT = PROJECT_ROOT + "/lib/ruby"
# require all the files in the lib ruby directory
Dir.foreach(LIB_RUBY_ROOT) {|f| require LIB_RUBY_ROOT + "/" + f unless [".",".."].include?(f)}
