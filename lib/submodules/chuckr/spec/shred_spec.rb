require File.dirname(__FILE__) + '/spec_helper.rb'

describe Chuckr::Shreds::Shred do
  before(:each) do
    @shred = Chuckr::Shreds::Shred.new
  end

  describe "when initialized" do
    it "should set uniq ID and defaults" do
      @shred.id.should == "Shred-|-#{@shred.object_id}" # shred_name-|-object_id
      @shred.ck.should == {}
    end
    it "should not loop or pass time" do
      @shred[:loop].should == false
      @shred[:time].should == false
    end
    it "should respond :to_chuck" do
      @shred.respond_to?(:to_chuck).should == true
      @shred.respond_to?(:to_chuck_inspect).should == true # for debug
    end
    it "should be able to attach to vm" do
      @shred.respond_to?(:set_vm_scope).should == true
      @shred.vm.should == nil
    end
    it "should be able to attach another shred"
    it "should be able to attach to events"
  end

  describe "when attaching VM" do
    it "should be able to connect local/remote (bin-udp)"
    it "should be able to resume shred"
  end
  
  describe "when attached to VM" do
    it "should be able to replace shred" do
      @shred.respond_to?(:replace!).should == true
    end
  end
  
  describe "when resuming shred" do
    it "should change and validate ID"
    it "should update/migrate shred events"
  end

end


describe Chuckr::Shreds::Moe do
  before(:each) do
    @shred = Chuckr::Shreds::Moe.new
  end
  it "should set volume to 0.5" do
    @shred[:gain].should == 0.5
  end
  it "should pass time for 100::ms" do
    @shred[:time].should == 100
  end
  it "should loop" do
    @shred[:loop].should == true
  end
  it "should increase by to 0.1" do
    @shred[:increase_by].should == 0.1
  end
  it "should set :sin_freq to 4000.0" do
    @shred[:sin_freq].should == 4000.0
  end
  it "should set :next to 1.0" do
    @shred[:next].should == 1.0
  end
  it "should return shred.ck" do
    @shred.to_chuck.gsub(" ","").should == "\n        Impulse i => BiQuad f => dac;\n        .99 => f.prad; \n        1 => f.eqzs;\n        0.0 => float v;\n        0.5 => f.gain;\n      \nwhile( true )\n{\n\n        1.0 => i.next;\n        Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;\n        v + 0.1 => v;\n        100::ms => now;\n      \n}\n".gsub(" ","")
  end
  it "should patch patches.."
end


describe Chuckr::Shreds::Foo do
  before(:each) do
    @shred = Chuckr::Shreds::Foo.new
  end
  it "should set volume to 0.2" do
    @shred[:gain].should == 0.2
  end
  it "should pass time for 100::ms" do
    @shred[:time].should == 100
  end
  it "should loop" do
    @shred[:loop].should == true
  end
  it "should mix by 0.1" do
    @shred[:mix_by].should == 0.1
  end
  it "should set a :pattern" do
    @shred[:pattern].should == [ 0, 2, 4, 7, 9, 11 ]
  end
  it "should return shred.ck" do
    @shred.to_chuck.gsub(" ","").should == "\n        SinOsc s => JCRev r => dac;\n        0.2 => s.gain;\n        0.1 => r.mix;\n        [ 0, 2, 4, 7, 9, 11 ] @=> int pattern[];\n      \nwhile( true )\n{\n\n        Std.mtof( 45 + Std.rand2(0,3) * 12 + pattern[Std.rand2(0,pattern.cap()-1)] ) => s.freq;\n        100::ms => now;\n      \n}\n".gsub(" ","")
  end
end

describe Chuckr::Shreds::Sndbuf do
  before(:each) do
    @shred = Chuckr::Shreds::Sndbuf.new
  end
  it "should pass time for 100::ms" do
    @shred[:time].should == 100
  end
  it "should loop" do
    @shred[:loop].should == true
  end
  it "should set :test_file to /tmp/test_file.wav" do
    @shred[:test_file].should == '/tmp/test_file.wav'
  end
end