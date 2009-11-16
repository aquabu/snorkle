# from the chuckr docs: http://github.com/lian/chuckr
require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'
vm = Chuckr::VM.new            # create and configure VM
vm.start                       # start VM-runtime
pp vm.status                   # return status

foo = Chuckr::Shreds::Foo.new  # create default 'foo'-shred
foo.attach vm                  # attach 'foo' to VM, and start processing shred
pp vm.shreds                   # show shreds, should include 'foo' now

sleep(5)

foo.set :time => 160           # sets foo time variable to 160
foo.replace!                   # recompile / replace shred

sleep(5)

foo.detach                     # detach VM
vm.add_shred foo               # different method to attach

sleep(5)

foo.set! :time => 200          # shortcut for set + replace!

sleep(5)

vm.stop                        # stops vm. force kill if needed
pp vm.status[:running]         # true|false
