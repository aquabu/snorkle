require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'
describe Atlatl::Note do
  context "without arguments" do
    before do
      @event = Atlatl::Note.new
    end

    it "has default pitch of 60" do
      @event.pitch.should == 60
    end

    it "has default duration of 1" do
      @event.duration.should == 1
    end
  end

  context "with arguments" do
    before do
      @event = Atlatl::Note.new(61, 2)
    end

    it "assigns pitch" do
      @event.pitch.should == 61
    end

    it "assigns duration" do
      @event.duration.should == 2
    end
  end
end