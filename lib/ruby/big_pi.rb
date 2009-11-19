class BigPi
  # pi here is calculated using Jay Anderson's method based on the LiteratePrograms Wiki implementation: http://rubyquiz.strd6.com/quizzes/202
  class << self
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

    def calc_pi_array(digits)
      result = calc_pi(digits).to_s.split("")
      result.map {|v| v.to_i}
    end

    def pi_array_with_offset(digits, offset)
      calc_pi_array(digits).map {|v| v + offset}
    end
  end
end