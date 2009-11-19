require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'

describe Atlatl::Sampler do
  describe "#play_sample_string" do
    before do
      @sampler = Atlatl::Sampler.new
      @result = @sampler.play_sample_string("foo.wav")
    end

    it "invokes chuck" do
      @result.should include("chuck")
    end
    
    it "refers to the chuck sample player with a full path" do
      @result.should include("lib/chuck/sample_player.ck")
    end
    
    it "passes in the sample name as an argument" do
      @result.should include("foo.wav")
    end

    it "should have the right syntax" do
      @result.should =~ /chuck.*sample_player.*\:.*'.*foo.wav/
    end
  end

  describe "#play_sample" do
    before do
      @sampler = Atlatl::Sampler.new
      @sampler.stub!(:system)
    end
    
    it "creates a string with the wav name" do
      @sampler.should_receive(:play_sample_string).with("foo.wav")
      @sampler.play_sample("foo.wav")
    end

    it "invokes chuck" do
      @sampler.should_receive(:system).with(@sampler.play_sample_string("foo.wav"))
      @sampler.play_sample("foo.wav")
    end
  end

  describe "#shred_keys" do
    before do
      @sampler = Atlatl::Sampler.new
      @sampler.stub!(:system)
      @sampler.stub!(:escape).and_return(true)
      @sampler.stub!(:puts).and_return(true)
      @sampler.stub!(:print).and_return(true)
    end

    context "with a keymapped character" do
      it "calls play" do
        @sampler.should_receive(:get_character).and_return(97) # 97 is a lowercase a
        @sampler.should_receive(:play_sample).with("snare.wav") # 97 is a lowercase a
        @sampler.shred_keys
      end
    end

    context "without a keymapped character" do
      before do
        @sampler.should_receive(:get_character).and_return(126) # 126 is th ~ (tilda) character
      end

      it "does not call play" do
        @sampler.should_not_receive(:play_sample)
        @sampler.shred_keys
      end
    end
  end
end