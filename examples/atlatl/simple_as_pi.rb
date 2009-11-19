# at some point in nearly everyone doing generative music decides to try out pi as music
# this usually not really all that musically satisfying. Here it is to save you the trouble :-)

require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

# load an instance of the Atlatl Chuck wrapper
@atlatl = Atlatl.new

# loop through our pi calculation and make some notes with our given offset
pitch_offset = 60
digits = 100

BigPi.pi_array_with_offset(digits, pitch_offset).each do |pitch|
  @atlatl.add_event(pitch, 0.25)
end

# render to an audio file silently in non-realtime
@atlatl.realtime = false

# save the file to the same folder as we are isnrkn
@atlatl.filename = File.expand_path(File.dirname(__FILE__)) + "/pi.wav"
@atlatl.render