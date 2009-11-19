require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

# setup the bloops o' phone instruments
b = Bloops.new
b.tempo = 310

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

chord = b.sound Bloops::SQUARE
chord.volume = 0.275
chord.attack = 0.05
chord.sustain = 1.0
chord.decay = 2.0
chord.phase = 0.35
chord.psweep = -0.25
chord.vibe = 0.0455
chord.vspeed = 0.255

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

def pause(beats)
  "4 " * beats
end

# generate the greek melodies
section_length = 48 # try 12, 32, 48, 64 - somewhere on your way to 128 you may hit gc issues
#b.tune square, greek_melody(section_length, 9, 12)
#b.tune sine, greek_melody(section_length, 17, 24, 6)
#b.tune beat, pause(section_length / 2) + greek_melody(section_length / 2, 7, 12)
#b.tune chord, greek_melody(section_length, 7, 32, 4)
# v2
#b.tune square, greek_melody(section_length, 7, 28)
#b.tune sine, greek_melody(section_length, 11, 16, 6)
#b.tune beat, pause(section_length / 2) + greek_melody(section_length / 2, 5, 12)
#b.tune chord, greek_melody(section_length, 7, 32, 4)

b.tune square, greek_melody(section_length, 9, 12) + greek_melody(section_length, 7, 28) + greek_melody(section_length, 9, 12)
b.tune sine, greek_melody(section_length, 17, 24, 6) + greek_melody(section_length, 11, 16, 6) + greek_melody(section_length, 17, 24, 6)
b.tune beat, pause(section_length / 2) + greek_melody(section_length / 2, 7, 12) + pause(section_length / 2) + greek_melody(section_length / 2, 7, 12) + pause(section_length / 2) + greek_melody(section_length / 2, 7, 12)
b.tune chord, greek_melody(section_length, 7, 32, 4) + greek_melody(section_length, 7, 32, 4) + greek_melody(section_length, 7, 32, 4)


b.play
sleep 1 while !b.stopped?