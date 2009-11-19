require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'
describe BigPi do
  it "returns pi to an arbitrary number of places" do
    BigPi.calc_pi(100).should == 31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
  end
end