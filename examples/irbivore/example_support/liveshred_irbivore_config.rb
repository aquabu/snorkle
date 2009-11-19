require File.expand_path(File.dirname(__FILE__)) + '/../../../config/init.rb'
module Irbivore::Config
  class << self
    def shred_keys
      sampler = Atlatl::Sampler.new
      sampler.shred_keys
    end
  end
end