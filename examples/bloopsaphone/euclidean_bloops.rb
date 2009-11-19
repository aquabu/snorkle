require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

# the bloops o' phone
b = Bloops.new
b.tempo = 320

square = b.sound Bloops::SQUARE
square.volume = 0.5
square.sustain = 0.1
square.attack = 0.1
square.decay = 0.3

# beats
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

# the tracks
# 10 possible notes
NOTES = %w{c c# d d# e f# g g# a b}
@lead_seq = EuclideanSequencer.generate_array(27,32)
@bass_seq = EuclideanSequencer.generate_array(19,32)
@beat_seq = EuclideanSequencer.generate_array(12,32)



# make melodie based on pi with a euclidean rhythm
def greek_melody(pi_length, hits, beats)
  melody = ""
  rhythm = EuclideanSequencer.generate_array(hits,beats)
  BigPi.calc_pi_array(32).each_with_index do |value, i|
    melody += rhythm[i] == 1 ? "#{NOTES[value]} " : "1 "
  end
  melody
end

lead_tune = greek_melody(32, 27, 32)

bass_tune = BigPi.calc_pi_array(32).inject("") do |result, value|
  result += "#{NOTES[((value + 6) % 10)]} " # make a harmony
end

beat_tune = BigPi.calc_pi_array(32).inject("") do |result, value|
  result += "#{NOTES[value]} "
end

puts @lead_seq.to_s
puts lead_tune
puts beat_tune

b.tune square, lead_tune
#b.tune sine, bass_tune
#b.tune beat, beat_tune
#
b.play
sleep 1 while !b.stopped?