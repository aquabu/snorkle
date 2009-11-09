// pull samples from the dac
dac => Gain g => WvOut w => blackhole;

// this is the output file name
"audio_render" => w.wavFilename;

SinOsc s => JCRev r => dac;
.5 => r.gain;
.075 => r.mix;

// loop through the command line arguments
for( int i; i < me.args(); i++ )
{

    // defaults
    60 => float note;
    1 => float duration;

    // break apart command line argument strings into note and duration
    StringTokenizer tok;
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

// pause to let the verb die
2::second => now;