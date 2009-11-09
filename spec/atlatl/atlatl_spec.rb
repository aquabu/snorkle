require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'
describe Atlatl do
  describe "default attributes" do
    before do
      @atlatl = Atlatl.new
    end
    it "has a default filename" do
      @atlatl.filename.should == "atlatl.wav"
    end
  end
  describe "renderer" do
    before do
      @atlatl = Atlatl.new
      @atlatl.add_event(65, 2)
      @atlatl.add_event(66, 0.5)
    end
    
    it "can store added notes" do
      @atlatl.sequence[0].class.should == Atlatl::Note
      @atlatl.sequence[0].pitch.should == 65
      @atlatl.sequence[0].duration.should == 2
    end
    
    it "can insert new events" do
      @atlatl.add_event_at(1,66,0.5)
      @atlatl.sequence[1].pitch.should == 66
      @atlatl.sequence[1].duration.should == 0.5
    end
  end

  describe "#sequence_to_string" do
    before do
      @atlatl = Atlatl.new
      @atlatl.add_event(65, 2)
      @atlatl.add_event(66, 0.5)
    end
    
    it "should return the current sequence as a string" do
      @atlatl.sequence_to_string.should == ":'65 2':'66 0.5'"
    end
  end

  describe "#chuck_args invocation string" do
    before do
      @atlatl = Atlatl.new
      @atlatl.add_event(65, 2)
      @atlatl.add_event(66, 0.5)
    end

    describe "in non realtime mode" do
      before do
        @atlatl.realtime = false
      end
      
      it "passes the -s flag" do
        @atlatl.chuck_string.should =~ /-s/
      end

      it "invokes the simple_render.ck chuck file" do
        @atlatl.chuck_string.should include("chuck #{PROJECT_ROOT}/lib/chuck/simple_render.ck")
      end

      it "invokes chuck with the filename" do
        @atlatl.chuck_string.should include "simple_render.ck:'atlatl.wav'"
      end
      
      it "passes the event sequence to chuck on the command line" do
        @atlatl.chuck_string.should include "simple_render.ck:'atlatl.wav':'65 2':'66 0.5'"
      end
    end

    describe "in audio playback mode" do
      it "does not pass the -s flag" do
        @atlatl.chuck_string.should_not =~ /-s/
      end
    end
  end
end