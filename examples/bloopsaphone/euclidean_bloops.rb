require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

# setup the bloops o' phone instruments
b = Bloops.new
b.tempo = 320

square = b.sound Bloops::SQUARE
square.volume = 0.5
square.sustain = 0.1
square.attack = 0.1
square.decay = 0.3

beat = b.sound Bloops::NOISE
beat.volume = 0.3
beat.punch = 0.5
beat.sustain = 0.2
beat.decay = 0.4
beat.slide = -0.4
beat.phase = 0.2
beat.psweep = 0.2

sine = b.sound Bloops::SINE
sine.volume = 0.7
sine.attack = 0.1
sine.sustain = 0.11
sine.decay = 0.2
sine.hpf = 0.2
sine.hsweep = -0.05
sine.resonance = 0.75
sine.phase = 0.4

# setup quantization for 10 pi digit values to 10 possible notes
NOTES = %w{c c# d d# e f# g g# a b}

# make melodie based on pi with a euclidean rhythm
# pi_length is the number of digits of pi that will be used mapped to the above notes
# rhythms will be wrapped to the total pi_length
# melody can be offset by an interval
def greek_melody(pi_length, hits, beats, melody_offset = 0)
  melody = ""
  rhythm = EuclideanSequencer.generate_array(hits,beats) # generate a euclidean rythm
  BigPi.calc_pi_array(pi_length).each_with_index do |value, i|
    melody += rhythm[i % rhythm.length] == 1 ? "#{NOTES[((value + melody_offset) % 10)]} " : "4 " # only play on the generated euclidean beats
  end
  puts "rhythm: #{rhythm}"
  puts "melody: #{melody}"
  melody
end

# generate the greek melodies
length = 63
b.tune square, greek_melody(length, 9, 12)
b.tune sine, greek_melody(length, 17, 24, 6)
b.tune beat, greek_melody(length, 7, 12)
#
b.play
sleep 1 while !b.stopped?