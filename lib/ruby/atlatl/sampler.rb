require "highline/system_extensions"
class Atlatl::Sampler
  include HighLine::SystemExtensions
  attr_accessor :sample_player, :sample_folder

  KEYMAP = {
          "a" => "909_kick.wav",
          "s" => "snare.wav",
          "d" => "core_fast_hats.wav",
          "f" => "core_wicked_bass_short.wav",
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
    puts "Play SAMPLES a (kick), s (snare), d (hats loop). Kick and snare are in time with the loop. To end type <esc>."
    start

    loop do
      char = get_character.chr
      print char

      play_shred_sample(KEYMAP[char]) unless skip?(char) # the threading helps the print display
       if escape(char)
         stop
         system "killall -HUP chuckr_bin" # brutally stop all chuckr processes
         return
      end
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
    shred.set :loop => false
    shred
  end

  def play_shred_sample(sample)
    shred = create_sample_shred(sample)
    shred.attach Atlatl::Sampler.vm
  end
end