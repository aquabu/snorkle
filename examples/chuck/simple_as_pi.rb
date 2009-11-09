# at some point in nearly everyone doing generative music decides to try out pi as music
# this usually not really all that musically satisfying. Here it is to save you the trouble :-)

require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'

# pi here is calculated using Jay Anderson's method based on the LiteratePrograms Wiki implementation: http://rubyquiz.strd6.com/quizzes/202
def arccot(x, unity)
    xpow = unity / x
    n = 1
    sign = 1
    sum = 0
    loop do
        term = xpow / n
        break if term == 0
        sum += sign * (xpow/n)
        xpow /= x*x
        n += 2
        sign = -sign
    end
    sum
end

def calc_pi(digits = 10000)
    fudge = 10
    unity = 10**(digits+fudge)
    pi = 4*(4*arccot(5, unity) - arccot(239, unity))
    pi / (10**fudge)
end

size = 100 # have as much pi as you would like
pi = calc_pi(size)

# load an instance of the Atlatl Chuck wrapper
@atlatl = Atlatl.new

# loop through our pi calculation and make some notes with our given offset
pitch_offset = 60
pi.to_s.split("").each do |number|
  pitch = pitch_offset + number.to_i
  @atlatl.add_event(pitch, 0.25)
end

# render to an audio file silently in non-realtime
@atlatl.realtime = false

# save the file to the same folder as we are in
@atlatl.filename = File.expand_path(File.dirname(__FILE__)) + "/pi.wav"
@atlatl.render