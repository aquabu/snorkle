# net.mattbot.class.euclidean_sequencer.rb
# by Matt Ridenour (mattridenour@gmail.com)
# Created on Sun Oct 26 2008
#
# A class for spaceing a number of ones over a range of zeros as evenly as possible using the Euclidean algorithm.
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
    outputArray = [0]
    thisSeq = euclid(hits,pulses).scan(/./)
    thisSeq.length.times do |element|
      outputArray[element] = thisSeq[element].to_i
    end
    return outputArray
  end

  def generate_with_offset(hits,pulses,offset)
    # Outputs a binary sequence using using ones and zeros which can be started on an offset.
    @sequence = [0]
    outputOffsetArray = [0]
    thisOffsetSeq = euclid(hits,pulses).scan(/./)
    thisOffsetSeq.length.times do |element|
      outputOffsetArray[element] = thisOffsetSeq[element].to_i
    end
    offset.times do |nudge|
      outputOffsetArray << outputOffsetArray.shift
    end
    return outputOffsetArray
  end

  private

  def euclid(hits,pulses)
    # The magickal euclidean algorithmical engine!

    # Contruct the sequence if new:
    if @sequence[0] == 0
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

    # Count the sequence element types (remainder or denominator) for distribution:
    remainder = 0
    denominator = 0
    @sequence.each do |element|
      if element == @sequence.last
        remainder = remainder + 1
      else
        denominator = denominator + 1
      end
    end

    # Determine how many sets of zeros can be nabbed from the pulses at a time,
    # insuring all the zeros get used up before the algorithm ends.
    if pulses > hits * 2
      # Must avoid division by zero:
      unless hits == 0
        if denominator == 0
          zeroSets = 1
        else
          # Grab as many zeros as possible:
          zeroSets = remainder/denominator
        end
        # But don't grab as many zeros as impossible:
        if zeroSets > @sequence.length
          zeroSets = 0
        end
        # Scrapping the bottom of the zero barrel:
        if zeroSets == 0 and remainder > 1
          zeroSets = 1
        end
      end
    else
      # The ratio of hits to pulses isn't so low as to start hording zeros:
      zeroSets = 1
    end

    # Choose the approiate counter for the current size of the sequence:
    if remainder > denominator
      numberOfDistributions = denominator
    else
      numberOfDistributions = remainder
    end

    # Determine if the algorithm has conclude or another iteration is neccessy:
    if hits == 0
      return @sequence.to_s
    else
      # Distribute the remainder into the denominator and pop the unnecessary elements:
      numberOfDistributions.times do |distribution|
        zeroSets.times do
            @sequence[distribution] << @sequence.pop unless @sequence[distribution].nil?
        end
      end
    end

    # Recursion:
    return euclid(pulses % hits,hits)
  end
end

# Debug:
#thisEC = EuclideanSequencer.new()
#
#33.times do |pulses|
#  pulses.times do |hits|
#    p thisEC.generate_array(hits+1,pulses)
#  end
#end

#p thisEC.generate_array(13,32)







