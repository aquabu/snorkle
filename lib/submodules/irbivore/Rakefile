require 'spec'
require File.expand_path(File.dirname(__FILE__)) + '/init.rb'
require 'rake/testtask'
require 'spec/rake/spectask'

task :default => [:specs]
desc "Run rspec specs"
Spec::Rake::SpecTask.new("specs") do |t| 
  t.spec_opts = ['--options', "\"#{File.expand_path(File.dirname(__FILE__))}/spec/spec.opts\""]
  file_list = FileList["spec/**/*_spec.rb"] 
  t.spec_files = file_list
end
