// record to a file by running this file like so
// chuck non_realtime.ck -s

// setup recording
// pull samples from the dac
dac => WvOut w => blackhole;

// Name the file
"chuck-session" => w.autoPrefix;
"special:auto" => w.wavFilename;

// print it out
<<<"writing to file: ", w.filename()>>>;

// play the whole tones demo
SinOsc s => JCRev r => dac;
.5 => r.gain;
.075 => r.mix;

// note number
20 => float note;

// go up to 127
while( note < 128 )
{
    // convert MIDI note to hz
    Std.mtof( note ) => s.freq;
    // turn down the volume gradually
    .5 - (note/256.0) => s.gain;

    // move up by whole step
    note + 2 => note;

    // advance time
    .125::second => now;
}

// turn off s
0 => s.gain;
// wait a bit
2::second => now;