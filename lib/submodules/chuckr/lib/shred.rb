module Chuckr
module Shreds
  class Shred < Hash
    attr_reader :id, :vm, :ck
    def initialize
      super # super to hash..
      @id, @vm, @ck = set_name, nil, {}
      merge! :id => @id, :loop => false, :time => false, :patch => [];
      setup if respond_to?(:setup)
    end
    
    def set(attributes); merge!(attributes); end
    def set!(attributes); set attributes; replace!; end
    def set_name(shred_name=nil); @id = "#{(shred_name || self.class.to_s.split("::").last)}-|-#{self.object_id}"; end
    def set_vm_scope(vm); @vm = vm; end
    def add_patch(var,patch_desc); self[:patch] << { var.to_sym => patch_desc }; end
  
    def attach(vm_or_shred)
      vm_or_shred.add_shred(self) if vm_or_shred.respond_to?(:add_shred) # is vm
      # if vm_or_shred.respond_to?(:attach) # is another shred
    end
    
    def detach
      if @vm && @vm.respond_to?(:remove_shred)
        @vm = nil if @vm.remove_shred @id
        return @vm == nil
      end
    end
  
    def replace!
      @vm.replace_shred(@id,self) if @vm && @vm.respond_to?(:replace_shred)
    end
    
    def setup_ck(string=nil,&block)
      @ck[:setup] = string || block
    end
    
    def process_ck(string=nil,&block)
      @ck[:process] = string || block
    end
    
    def to_chuck
      ck_out = []
      
      if @ck[:setup]
        begin
          case @ck[:setup]
            when Proc
              ck_out << @ck[:setup].call
            when String
              ck_out << @ck[:setup]
          end
        rescue Exception => e
          raise "ERROR:to_chuck @ck[:setup]: #{e.inspect} #{e.backtrace}"
        end
      end
      
      if @ck[:process]
        begin
          case @ck[:process]
            when Proc
              ck_process = @ck[:process].call
            when String
              ck_process = @ck[:process]
            else
              ck_process = nil
          end
          unless self[:loop]
            ck_out << ck_process
          else
            ck_out << "while( true )\n{\n#{ck_process}\n}\n"
          end
        rescue Exception => e
          raise "ERROR:to_chuck @ck[:process]: #{e.inspect} #{e.backtrace}"
        end
      end
      
      ck_out.join("\n")
    end
    
    def to_chuck_inspect
      msg="#{inspect}\n#{to_chuck}";print("\n#{msg}\n");msg
    end
    
    
   #### helpers
    def read_file(file_path, var="buf")
      %{"#{file_path}" => #{var}.read} if File.exists?(file_path)
    end
  end # Shred
end # Shreds
end # Chuckr