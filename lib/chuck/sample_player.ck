// this synchronizes to period
.25::second => dur T;
T - (now % T) => now;

// sound file
"./snare.wav" => string filename;
if( me.args() ) me.arg(0) => filename;

// the patch
SndBuf buf => dac;

// load the file
filename => buf.read;

0 => buf.pos;
repeat( buf.samples() ) {
    1::samp => now;
}