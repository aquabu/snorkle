require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'
vm = Chuckr::VM.new            # create and configure VM
vm.start                       # start VM-runtime
while(!vm.status[:running])
  sleep(0.1)
end
pp vm.status                   # return status

sampler = Chuckr::Shreds::SamplePlayer.new   # create a sampler
sampler.set :sample => PROJECT_ROOT + "/lib/samples/snare.wav"
sampler.attach vm                       # attach the sampler to the vm
pp vm.shreds                   # show shreds, should include 'foo' now
sleep(2)
vm.stop