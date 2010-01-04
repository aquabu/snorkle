require File.dirname(__FILE__) + "/../vendor/ruby-session/lib/session.rb"

module Chuckr
  class VM
    attr_accessor :status, :config
    def initialize(args={})
      @config = { :port => 4031, :host => "localhost", :tmp_path => "/tmp/chuckr" }.merge(args)
      @config[:root_path] = @config[:root_path] || "#{@config[:tmp_path]}/vm-#{@config[:port]}"
      init_status
      @shell = Session::Shell.new
      @shreds, @shreds_binding, @pid = {}, {}, nil
    end

    def init_status
      @status = { :running => false, :now => 0, :samps => 0 }
    end

    def log(str,new_line=true)
      print("#{str}#{new_line ? "\n" : nil}")
    end

    def start
      chuck_configure
      chuck_start
    end
    
    def stop
      begin
        chuck_run '--kill'; sleep 0.3;
        @shell.close; @shell = Session::Shell.new 
        init_status
      rescue Exception => e
        # ..
      end
      VM.chuck_force_kill(@config[:port])
    end

    def inject_scope(shred);
      shred.set_vm_scope(self) if shred.respond_to?(:set_vm_scope)
    end

    def add_shred(shred)
      if shred_object?(shred)
        inject_scope(shred)
        log "attach #{shred.id}", false
        if shred_file_path = write_tmp_ck(shred)
          chuck_run "--add \"#{shred_file_path}\""
          chuck_run '--status'
          log " ( ok )";
          return true
         else
          log " ( error ) #{shred_file_path}"
        end
      end
    end
    
    def remove_shred(shred_id)
      if shred = shreds[shred_id]
        log "detach #{shred_id} #{shred.inspect}", false
        @shreds.delete(shred_id)
        chuck_run "--remove #{shred[:spork_id]}"
        log " ( ok )";
        return true
      end
    end
    
    def replace_shred(shred_id,shred)
      if shred_object?(shred)
        if old_shred = @shreds[shred_id]
          log "replace #{shred_id} with #{shred.id}", false
          if shred_file_path = write_tmp_ck(shred)
            chuck_run "--replace \"#{old_shred[:spork_id]}\" \"#{shred_file_path}\""
            chuck_run '--status'
            log " ( ok )";
            return true
          else
            log " ( error ) => #{shred_file_path}"
          end
        end
      end
    end

    def shred_object?(o)
      o.respond_to?(:to_chuck) && o.respond_to?(:id)
    end
    
    def write_tmp_ck(shred) # replace by sending string to socket instead chuck_run
      path = "#{@config[:root_path]}/tmp/#{shred.id}.ck"
      if shred_object?(shred)
        File.open(path,"wb") { |f| f.print shred.to_chuck };
        path
      end
    end

    def chuck_configure
      Dir.mkdir(@config[:tmp_path]) unless File.exists?(@config[:tmp_path])
      Dir.mkdir(@config[:root_path]) unless File.exists?(@config[:root_path])
      Dir.mkdir(@config[:root_path]+"/tmp") unless File.exists?(@config[:root_path]+"/tmp")
    end

   
    def status
      chuck_run '--status'; @status
    end
    
    def shreds
      chuck_run '--status'; @shreds
    end
    
    def chuck_stdout_callback(stdout)
      matched = false

      # [chuck](VM): status (now == 0h0m24s, 1063168.0 samps)
      if stdout.match /status \(now == (.+), (.+) samps/
        @status[:now], @status[:samps], @status[:running], matched = $1, $2, true, true
        tick_callback :status
      end
      
      # [shred id]: 1  [source]: foo.ck  [sporked]: 21.43s ago
      if stdout.match /\[shred id\]\: (.+)  \[source\]: (.+)\.ck  \[spork time\]\: (.+)s ago/
        matched = true
        @shreds[$2] = { :spork_id => $1, :sporked => $3 }
        tick_callback :shreds
      end
      
      # [chuck](VM): replacing shred 1 (Foo-|-20614740.ck) with 1 (Foo-|-20614748.ck)...
      # [chuck](VM): sporking incoming shred: 1 (Foo-|-20614280.ck)...
      if stdout.match /(replacing|incoming|removing) shred/
        matched = true # ...
      end
      
      # match if chunkr_bin vm got killed
      if stdout.match /[0-9] Terminated/
        @status[:now], @status[:samps], @status[:running], matched = 0, 0, false, true
        tick_callback :vm_killed
      end
      
      # print & log unmatched stdout
      log "Stdout[unmatched]: #{stdout.chomp}" unless matched

      return true # callback allway true
    end
    
    def tick_callback(type)
      # log "tick_callback: #{type.to_s}";true
    end

    def chuck_start
      VM.chuck_check_binary
      VM.chuck_force_kill(@config[:port])
      pipe_callback = lambda{ |stdout| chuck_stdout_callback(stdout) } 
      @shell.outproc, @shell.errproc = pipe_callback, pipe_callback
      @shell_thread = Thread.new do
        @shell.execute( chuck_command("--loop") ) #  :stdout => @out, :stderr => @err
      end;sleep(0.6)
      return status.merge(:running => true) # force true instead wait.
    end

    def chuck_command(cmd);"#{CHUCK_BIN} -p#{@config[:port] || 4031} #{cmd}";end
    def chuck_run(cmd_args);system(chuck_command(cmd_args));end
  end # VM
  
  class VM
    def self.start(args)
      vm = new(args)
      if vm.start
        puts "VM started at #{vm.config[:host]}:#{vm.config[:port]}\n"; sleep(0.2);
      else
        puts "VM faild to start at #{CHUCK_BIN} with => #{vm.config.inspect}\n";
      end
      vm
    end
    def self.chuck_check_binary
      raise "CHUCK_BIN is missing! try 'rake chuck:setup'" unless File.exists?(CHUCK_BIN) && File.executable?(CHUCK_BIN)
    end
    def self.chuck_force_kill(port=nil)
      raise "pass a port to force_kill" unless port
      pids = `ps aux | grep -v "grep" | grep "chuckr_bin -p#{port} --loop"`.split("\n")
      pids.each { |line| pid = line.split(" ")[1];
        system("kill #{pid}"); sleep(0.2)
        puts "CHUCK_BIN pid:#{pid} force killed!"
      };true
    end
  end # VM.self
end # Chuckr