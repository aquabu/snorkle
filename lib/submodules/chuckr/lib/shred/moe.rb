module Chuckr
module Shreds
  class Moe < Shred
    def setup
      # add_patch :impulse, "Impulse => BiQuad => dac"
      set :gain => 0.5, :time => 100, :loop => true
      set :next => 1.0, :sin_freq => 4000.0, :increase_by => 0.1
      
      setup_ck do
        %{
          Impulse i => BiQuad f => dac;
          .99 => f.prad; 
          1 => f.eqzs;
          0.0 => float v;
          #{self[:gain]} => f.gain;
        }
      end
      
      process_ck do
        %{
          #{self[:next]} => i.next;
          Std.fabs(Math.sin(v)) * #{self[:sin_freq]} => f.pfreq;
          v + #{self[:increase_by]} => v;
          #{self[:time]}::ms => now;
        }
      end
    end
  end # Moe
end # Shreds  
end # Chuckr

##### basic/moe.ck
##  // run each stooge, or run three stooges concurrently
##  // %> chuck moe larry curly
##  
##  // impulse to filter to dac
##  Impulse i => BiQuad f => dac;
##  // set the filter's pole radius
##  .99 => f.prad; 
##  // set equal gain zeros
##  1 => f.eqzs;
##  // initialize float variable
##  0.0 => float v;
##  // set filter gain
##  .5 => f.gain;
##    
##  // infinite time-loop   
##  while( true )
##  {
##      // set the current sample/impulse
##      1.0 => i.next;
##      // sweep the filter resonant frequency
##      Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
##      // increment v
##      v + .1 => v;
##      // advance time
##      100::ms => now;
##  }