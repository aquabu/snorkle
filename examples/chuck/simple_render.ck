// pull samples from the dac
dac => Gain g => WvOut w => blackhole;

// this is the output file name
"audio_render" => w.wavFilename;

// play the whole tones demo
SinOsc s => JCRev r => dac;
.5 => r.gain;
.075 => r.mix;

// note number
20 => float note;


// print each
for( int i; i < me.args(); i++ )
{
    // get an argument from the chuck call and store as a note
    Std.atoi( me.arg(i) ) => int note;

    // convert arg to hz and play it
    Std.mtof( note ) => s.freq;

    // advance time
    .5::second => now;
}

// turn off s
0 => s.gain;
// wait a bit
1::second => now;