class Lilypond
  attr_accessor :temp_file, :note_string, :output_file, :header
  
  def initialize(opts = {})
    @temp_file = "temp.ly"
    @output_file = "temp.pdf"
    @note_string = opts[:note_string] || ""
    @header = opts[:header] || ""
  end

  def lilypond_doc
<<DOC
\\header {
  title = "#{header}"
}

\\relative {
  #{note_string}
}

\\version "2.12.2"
DOC
  end

  def command_string
    "lilypond #{temp_file}"
  end

  def create_temp_file
    File.open(temp_file, 'w+') {|f| f.write(lilypond_doc) }
  end

  def render
    create_temp_file
    system "#{LILYPOND_PATH} #{temp_file}"
  end
end