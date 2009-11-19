require "highline/system_extensions"
class Atlatl::Sampler
  include HighLine::SystemExtensions

  KEYMAP = {
    "a" => "snare.wav",
    "s" => "909_kick.wav",
    "d" => "core_bass.wav",
    "f" => "core_drums.wav",
    "g" => "core_fast_hats.wav",
    "h" => "core_wicked_bass_short.wav"
  }
  
  def shred_keys
    puts "Play SAMPLES. To end type <esc>."
    loop do
      char = get_character.chr
      print char

      play_sample(KEYMAP[char]) unless skip?(char) # the threading helps the print display
      return if escape(char)
    end
  end

  def escape(key)
    key == "\e"
  end

  # skips midiator_keys that should not play anything (ie. are not defined)
  def skip?(char)
    !KEYMAP.include? char
  end

  def initialize
    @sample_player_path = "#{PROJECT_ROOT}/lib/chuck/sample_player.ck"
    @sample_folder = "#{PROJECT_ROOT}/lib/samples"
  end
  
  def play_sample_string(sample_name)
    "chuck #{@sample_player_path}:'#{@sample_folder}/#{sample_name}'"
  end

  def play_sample(sample)
    system play_sample_string(sample)
  end
end