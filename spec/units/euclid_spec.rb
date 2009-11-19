require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'

describe EuclideanSequencer do
  before do
    @seq = EuclideanSequencer.new
  end

  it "has a default sequnce" do
    @seq.sequence.should == [0]
  end

  describe "#generate" do
    it "can generate a euclidean sequence as a string" do
      @seq.generate(5,8).should == "10110101"
    end
    
    describe "sample output" do
      it "can generate a 7 hit 12 pulse string" do
        @seq.generate(7,12).should == "101101010110"
      end
      it "can generate a 9 hit 13 pulse string" do
        @seq.generate(9,13).should == "1011011011011"
      end
    end
  end

  describe "#generate_array" do
    it "can generate a euclidean sequence as an array" do
      @seq.generate_array(5,8).should == [1, 0, 1, 1, 0, 1, 0, 1]
    end

    describe "sample output" do
      it "can generate a 7 hit 12 pulse array" do
        @seq.generate_array(7,12).should == [1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0]
      end

      it "can generate a 9 hit 13 pulse array" do
        @seq.generate_array(9,13).should == [1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1]
      end
    end
  end

  describe "#generate_with_offset" do
    it "can generate with an offset" do
      @seq.generate_with_offset(5,8, 1).should == [0, 1, 1, 0, 1, 0, 1, 1]
    end
  end

  describe "#construct_sequence" do
    it "with 5 hits and 8 pulses it returns" do
      @seq.construct_sequence(5,8)
      @seq.sequence.should == ["1", "1", "1", "1", "1", "0", "0", "0"]
    end

    it "with 7 hits and 12 pulses it returns" do
      @seq.construct_sequence(7,12)
      @seq.sequence.should == ["1", "1", "1", "1", "1", "1", "1", "0", "0", "0", "0", "0"]
    end
  end
end