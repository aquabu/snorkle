# manages ruby calls to chuck and renders wav files

class Atlatl
  attr_accessor :sequence, :realtime, :filename
  def initialize
    @sequence = []
    @realtime = true
    @filename = "atlatl.wav"
  end

  def add_event(*args)
    sequence << Note.new(*args)
  end

  def add_event_at(i, *args)
    sequence.insert(i, Note.new(*args))
  end


  def sequence_to_string
    sequence.map do |event|
      ":'#{event.pitch} #{event.duration}'"
    end.to_s
  end

  def chuck_string
    string = "chuck"
    string += " #{PROJECT_ROOT}/lib/chuck/simple_render.ck"
    string += ":'#{filename}'"
    string += sequence_to_string
    string += " -s" unless realtime
    string
  end
  
  class Note
    attr_accessor :pitch, :duration
    def initialize(*args)
      @pitch = args[0] || 60
      @duration = args[1] || 1
    end
  end
end