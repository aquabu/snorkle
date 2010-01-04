#! /usr/bin/env ruby
require 'rubygems'
require 'irb'
require 'irb/completion'
require 'boson'
require File.expand_path(File.dirname(__FILE__)) + '/init.rb'

if ARGV[0]
  require ARGV[0];
  ARGV[0] = nil
else
  require File.expand_path(File.dirname(__FILE__)) + '/config.rb'
end

puts "\n\n\n"
puts "Irbivore welcomes you"
puts "Commands: midiator_keys, play, type 'commands' for a full listing"
Boson.start :libraries => [Irbivore::Livecoding, Irbivore::Config], :verbose => false
Irbivore::Livecoding.setup
IRB.start
