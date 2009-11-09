class SimpleRender
  class Event
    attr_accessor :pitch, :duration
    def initialize(*args)
      @pitch = args[0] || 60
      @duration = args[1] || 1
    end
  end
end