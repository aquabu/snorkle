module Chuckr
  CHUCK_BIN = File.dirname(__FILE__) + "/../bin/chuckr_bin"
  CHUCK_TMP = "/tmp/chuckr_vm"
end

# require the chuck vm
require File.dirname(__FILE__) + "/vm.rb"
require File.dirname(__FILE__) + "/shred.rb"

# require standard shreds, gives you a base to start
require File.dirname(__FILE__) + "/shred/foo.rb"
require File.dirname(__FILE__) + "/shred/moe.rb"
require File.dirname(__FILE__) + "/shred/sndbuf.rb"

# require commandline interface
# require File.dirname(__FILE__) + "/cli.rb"