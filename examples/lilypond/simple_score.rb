require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

@lilypond = Lilypond.new(:note_string => "c d e f g", :header => "")
@lilypond.render
pp @lilypond.lilypond_doc
system "open #{@lilypond.output_file}"
