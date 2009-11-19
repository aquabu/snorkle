require 'rubygems'
require 'midiator'

midi = MIDIator::Interface.new
midi.use :dls_synth
midi.instruct_user!

include MIDIator::Notes
midi.control_change(32, 10, 1)
midi.program_change(10, 26)

16.times do
  midi.note_on 40, 10, 65
  midi.note_off 40, 10, 65
  midi.note_on 40, 10, 65
  midi.note_off 40, 10, 65
  sleep(0.3)
end

