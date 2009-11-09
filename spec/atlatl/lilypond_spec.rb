require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'
describe Lilypond do
  describe "#command_string" do
    before do
      @lilypond = Lilypond.new("a b c")
    end
    
    it "it includes lilypond command" do
      @lilypond.command_string.should include("lilypond")
    end

    it "includes path to the ly file" do
      @lilypond.command_string.should include("temp.ly")
    end
  end

  describe "#lilypond_doc" do
    before do
      @lilypond = Lilypond.new(:note_string => "a b c")
    end

    it "includes the note string" do
      @lilypond.lilypond_doc.should include("a b c")
    end
  end
end