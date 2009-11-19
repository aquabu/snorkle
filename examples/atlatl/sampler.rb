require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

@sampler = Atlatl::Sampler.new
@sampler.start
sleep(5) # wait for chuck to start
@sampler.play_shred_sample("snare.wav")
@sampler.stop