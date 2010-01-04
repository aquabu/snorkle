require 'rubygems'
require 'midiator'
IRBIVORE_ROOT = File.expand_path(File.dirname(__FILE__))

# require all the lib files
$: << IRBIVORE_ROOT + "/lib"
Dir.glob(IRBIVORE_ROOT + "/lib/*.rb") do |file|
   require file
end
