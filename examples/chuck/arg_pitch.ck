//Sine signal path
SinOsc s => dac;                    
//ASCII arg to int
Std.atoi( me.arg(0) ) => int freq; 
//MIDi note number to frequency
Std.mtof( freq ) => s.freq;         
//Advance time (play)
1::second => now;                   
