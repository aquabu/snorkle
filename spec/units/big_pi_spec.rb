require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'
describe BigPi do
  describe "#calc_pi" do
    it "returns pi to an arbitrary number of places" do
      BigPi.calc_pi(100).should == 31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
    end
  end

  describe "#calc_pi_array" do
    before do
      @result = BigPi.calc_pi_array(20)
    end

    it "returns an array of pi values" do
      @result.should == [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4, 6]
    end

    it "has values that are integers" do
      @result[0].should == 3
    end
  end


  describe "#pi_array_with_offset" do
    before do
      @result = BigPi.pi_array_with_offset(10, 60)
    end
    
    it "returns an array with the given offset" do
      @result.should == [63, 61, 64, 61, 65, 69, 62, 66, 65, 63, 65]
    end
  end
end