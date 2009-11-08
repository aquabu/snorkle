// pull samples from the dac
dac => Gain g => WvOut w => blackhole;

// this is the output file name
"audio_render" => w.wavFilename;

// play the whole tones demo
SinOsc s => JCRev r => dac;
.5 => r.gain;
.075 => r.mix;

for( int i; i < me.args(); i++ )
{

    // make one
    StringTokenizer tok;

    // defaults
    60 => float note;
    1 => float duration;

    // break apart argument string into note and duration
    tok.set( me.arg(i) );
    Std.atoi( tok.next() ) => note;
    Std.atoi( tok.next() ) => duration;

    // convert arg to hz and play it
    Std.mtof( note ) => s.freq;

    // advance time
    ( .5::second / duration ) => now;
}

// turn off s
0 => s.gain;
// wait a bit for reverb to die out
2::second => now;