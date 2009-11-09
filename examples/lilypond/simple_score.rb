require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

@lilypond = Lilypond.new(:note_string => "c d e f g")
@lilypond.create_temp_file
# @lilypond.render
# system "open #{@lilypond.output_file}"