module Chuckr
module Shreds
  class Foo < Shred
    def setup
      # add_patch :SinOsc, "SinOsc => JCRev => dac"
      set :loop => true, :time => 100, :gain => 0.2, :mix_by => 0.1, :pattern => [ 0, 2, 4, 7, 9, 11 ]
      set :pattern => [ 0, 2, 4, 7, 9, 11 ]

      setup_ck do
        %{
          SinOsc s => JCRev r => dac;
          #{self[:gain]} => s.gain;
          #{self[:mix_by]} => r.mix;
          [ #{self[:pattern].collect {|u| u.to_i}.join(", ")} ] @=> int pattern[];
        }
      end

      process_ck do
        %{
          Std.mtof( 45 + Std.rand2(0,3) * 12 + pattern[Std.rand2(0,pattern.cap()-1)] ) => s.freq;
          #{self[:time]}::ms => now;
        }
      end
    end
  end # Foo
end # Shreds  
end # Chuckr

##### basic/foo.ck
##  // hello everyone.
##  // a chuck is born...
##  // its first words:
##  
##  SinOsc s => JCRev r => dac;
##  .2 => s.gain;
##  .1 => r.mix;
##  
##  // an array
##  [ 0, 2, 4, 7, 9, 11 ] @=> int hi[];
##  
##  while( true )
##  {
##      Std.mtof( 45 + Std.rand2(0,3) * 12 +
##          hi[Std.rand2(0,hi.cap()-1)] ) => s.freq;
##      100::ms => now;
##  }