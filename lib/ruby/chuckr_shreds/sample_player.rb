module Chuckr
module Shreds
  class SamplePlayer < Shred
    def setup
      set :loop => true, :time => 100, :sample => "snare.wav"

      setup_ck do
        <<-CHUCK
          // this synchronizes to period
          .5::second => dur T;
          T - (now % T) => now;

          // sound file
          "#{self[:sample]}" => string filename;

          // the patch
          SndBuf buf => dac;

          // load the file
          filename => buf.read;
          0 => buf.pos;
          repeat( buf.samples() ) {
              1::samp => now;
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