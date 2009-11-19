module Chuckr
module Shreds
  class SamplePlayer < Shred
    def setup
      set :sample => "snare.wav", :loop => false

      setup_ck do
        <<-CHUCK
          // this synchronizes to period
          1::second => dur T;
          T - (now % T) => now;

          // sound file
          "#{self[:sample]}" => string filename;

          // the patch
          SndBuf buf => dac;

          // load the file
          filename => buf.read;
          
          while(true) {
            0 => buf.pos;
            repeat( buf.samples() ) {
                1::samp => now;
            }

              if (!#{self[:loop]}) {
                  break;
              }
          }
        CHUCK
      end

      process_ck do
        <<-CHUCK

        CHUCK
      end
    end
  end
end
end