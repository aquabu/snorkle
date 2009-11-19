// render a from a sequence of notes
// first argument is the filename
// next arguments are strings in the format note name then duration in seconds
// chuck simple_render.ck:'this.wav':'60 0.5'


// pull samples from the dac
dac => Gain g => WvOut w => blackhole;

// Setup unit generator graph
SinOsc s => JCRev r => dac;
.5 => r.gain;
.075 => r.mix;

// get the filename from the first argument
0 => int i;
me.arg(i) => w.wavFilename;
i++;

// loop through the command line arguments after the file name
for( i; i < me.args(); i++ )
{
    // defaults
    60 => float note;
    1 => float duration;

    // break apart command line argument strings into note and duration
    StringTokenizer tok;
    tok.set( me.arg(i) );
    Std.atof( tok.next() ) => note;
    Std.atof( tok.next() ) => duration;

    // convert arg to hz and play it
    Std.mtof( note ) => s.freq;

    // advance time
    ( 1::second * duration ) => now;
}

// turn off s
0 => s.gain;

// pause to let the verb die
2::second => now;
