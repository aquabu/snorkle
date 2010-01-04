module Chuckr
module Shreds
  class Sndbuf < Shred
    def setup
      # add_patch :buf, "SndBuf => dac"
      set :loop => true, :time => 100, :test_file => "/tmp/test_file.wav"
      
      setup_ck do
        %{
          SndBuf buf => dac;
          #{ read_file( self[:test_file], 'buf' ) }
        }
      end
  
      process_ck do
        %{
          0 => buf.pos;
          Std.rand2f(.2,.9) => buf.gain;
          Std.rand2f(.5,1.5) => buf.rate;
          #{self[:time]}::ms => now;
        }
      end
    end
  end # Sndbuf
end # Shreds  
end # Chuckr

#### sndbuf.ck
##  // the patch 
##  SndBuf buf => dac;
##  // load the file
##  filename => buf.read;
##  
##  // time loop
##  while( true )
##  {
##      0 => buf.pos;
##      Std.rand2f(.2,.9) => buf.gain;
##      Std.rand2f(.5,1.5) => buf.rate;
##      100::ms => now;
##  }