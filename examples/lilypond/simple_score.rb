require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

@lilypond = Lilypond.new(:note_string => "c d e f g", :header => "")
@lilypond.render
system "open #{@lilypond.output_file}"
