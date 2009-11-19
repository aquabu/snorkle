# net.mattbot.class.euclidean_sequencer.rb
# by Matt Ridenour (mattridenour@gmail.com)
# Created on Sun Oct 26 2008
# refactored by Noah Thorp

# A class for spacing a number of ones over a range of zeros as evenly as possible using the Euclidean algorithm.
#
# For more information on using the Euclidean algorithm in the context of music, please read:
# The Euclidean Algorithm Generates Traditional Musical Rhythms by Godfried Toussaint
# http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf
#
# Special thanks to Wesen for bringing Euclidean sequencing to my attention and forging the way using Lisp:
# http://ruinwesen.com/blog?id=216
#
# Usage:
# require "/path/to/net.mattbot.class.euclidean_sequencer.rb"
# pulses = 8
# hits = 5
# thisEC = EuclideanSequencer.new()
# p thisEC.generate(hits,pulses)
#
# Oontz!

class EuclideanSequencer
  attr_accessor :sequence
  def initialize
    @sequence = [0]
  end

  def generate(hits,pulses)
    # Outputs a binary sequence using ones and zeros.
    @sequence = [0]
    return euclid(hits,pulses)
  end

  def generate_array(hits,pulses)
    # Outputs a binary sequence using ones and zeros in a Max/MSP-list-friendly array.
    @sequence = [0]
    output_array = [0]
    this_seq = euclid(hits,pulses).scan(/./)
    this_seq.length.times do |element|
      output_array[element] = this_seq[element].to_i
    end
    return output_array
  end

  def generate_with_offset(hits,pulses,offset)
    # Outputs a binary sequence using using ones and zeros which can be started on an offset.
    @sequence = [0]
    output_offset_array = [0]
    this_offset_seq = euclid(hits,pulses).scan(/./)
    this_offset_seq.length.times do |element|
      output_offset_array[element] = this_offset_seq[element].to_i
    end
    offset.times do |nudge|
      output_offset_array << output_offset_array.shift
    end
    return output_offset_array
  end


  # The magickal euclidean algorithmical engine!
  def euclid(hits,pulses)
    return @sequence.to_s if hits == 0 #terminate recursion if done
    construct_sequence(hits, pulses) if @sequence[0] == 0
    remainder, denominator = count_element_types
    zero_sets = determine_zero_sets(hits, pulses, remainder, denominator)
    number_of_distributions = choose_counter(remainder, denominator)

    distribute_remainder(zero_sets, number_of_distributions)
    euclid(pulses % hits,hits)
  end

  # Distribute the remainder into the denominator and pop the unnecessary elements:
  def distribute_remainder(zero_sets, number_of_distributions)
    number_of_distributions.times do |distribution|
      zero_sets.times do
        @sequence[distribution] << @sequence.pop unless @sequence[distribution].nil?
      end
    end
  end

  # Choose the appropriate counter for the current size of the sequence
  def choose_counter(remainder, denominator)
    remainder > denominator ? denominator : remainder
  end

  # Determine how many sets of zeros can be nabbed from the pulses at a time,
  # insuring all the zeros get used up before the algorithm ends.
  def determine_zero_sets(hits, pulses, remainder, denominator)
    if pulses > hits * 2
      # Must avoid division by zero:
      unless hits == 0
        if denominator == 0
          zero_sets = 1
        else
          # Grab as many zeros as possible:
          zero_sets = remainder/denominator
        end
        # But don't grab as many zeros as impossible:
        if zero_sets > @sequence.length
          zero_sets = 0
        end
        # Scraping the bottom of the zero barrel:
        if zero_sets == 0 and remainder > 1
          zero_sets = 1
        end
      end
    else
      # The ratio of hits to pulses isn't so low as to start hording zeros:
      zero_sets = 1
    end
    zero_sets
  end

  # Count the sequence element types (remainder or denominator) for distribution:
  def count_element_types
    remainder = denominator = 0
    @sequence.each do |element|
      element == @sequence.last ? remainder += 1 : denominator += 1
    end
    return remainder, denominator
  end

  # Contruct the sequence if new
  def construct_sequence(hits, pulses)
    # @sequence = (["1"] * hits) + (["0"] * (pulses - hits) )
    hits.times do |hit|
      @sequence[hit] = "1"
    end

    pulses.times do |pulse|
      @sequence[hits + pulse] = "0"
    end

    hits.times do |hit|
      @sequence.pop
    end
  end
end






