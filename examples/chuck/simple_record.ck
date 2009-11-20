SinOsc s => dac;

// pull samples from the dac for recording
dac => WvOut w => blackhole;

// set file name
"simple_record.wav" => w.wavFilename;

1::second => now;