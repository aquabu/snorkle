#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__)) + '/../../config/init.rb'
samples   = []
scheduler = Gamelan::Scheduler.new(:tempo => 60)
times = 1000
1.upto(times) do |n|
  scheduler.at(0.001 * n, samples) do |samples|
    samples.push([time, Time.now])
  end
end

scheduler.run
sleep(ARGV.shift || 1.01).to_i
scheduler.stop

error  = samples.map { |(l,c)| (c.to_f - l) * times }
mean   = (error.inject(0) { |a,b| a + b } / error.size)
deriv  = error.map { |e| (e - mean) ** 2 }
var    = (deriv.inject(0) { |a,b| a + b } / deriv.size)
stddev = Math.sqrt(var)

puts "sample size\t\t%i"          % samples.size
puts "average jitter\t\t%.5fms"   % (error.inject(0) { |a,b| a + b } / error.size)
puts "peak jitter\t\t%.5fms"      % error.max
puts "standard deviation\t%.5fms" % stddev
#puts error.map { |sec| sprintf("%2.3fms", sec) }
