require "highline/system_extensions"
class Atlatl::Sampler
  include HighLine::SystemExtensions
  attr_accessor :sample_player, :sample_folder

  KEYMAP = {
          "a" => "909_kick.wav",
          "s" => "snare.wav",
          "d" => "core_fast_hats.wav",
          "f" => "core_drums.wav",
          "g" => "core_rhodes.wav",
          "h" => "core_bass.wav",
          "j" => "core_clave.wav",
          "k" => "core_barimbau_2.wav",
          "l" => "core_wicked_bass_short.wav",
          }

  # call vm.start and vm.stop before using sampler
  def self.vm
    @vm ||= Chuckr::VM.new
  end

  def initialize
    @sample_player_path = "#{PROJECT_ROOT}/lib/chuck/sample_player.ck"
    @sample_folder = "#{PROJECT_ROOT}/lib/samples"
  end

  def start
    Atlatl::Sampler.vm.start
  end

  def stop
    Atlatl::Sampler.vm.stop
  end

  def shred_keys
    puts "Play SAMPLES. To end type <esc>."
    start

    loop do
      char = get_character.chr
      print char

      play_shred_sample(KEYMAP[char]) unless skip?(char) # the threading helps the print display
      (stop; return) if escape(char)
    end

  end

  def escape(key)
    key == "\e"
  end

  # skips midiator_keys that should not play anything (ie. are not defined)
  def skip?(char)
    !KEYMAP.include? char
  end


  def play_command_line_sample_string(sample_name)
    "chuck + #{@sample_player_path}:'#{@sample_folder}/#{sample_name}'"
  end

  def play_command_line_sample(sample)
    system play_command_line_sample_string(sample)
  end

  def create_sample_shred(sample)
    shred = Chuckr::Shreds::SamplePlayer.new
    shred.set :sample => @sample_folder + "/" + sample
    shred
  end

  def play_shred_sample(sample)
    shred = create_sample_shred(sample)
    shred.attach Atlatl::Sampler.vm
  end
end