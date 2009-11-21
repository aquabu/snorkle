require File.expand_path(File.dirname(__FILE__)) + '/config/init.rb'
task :default => [:tests]

require 'rake/testtask'
require 'spec/rake/spectask'
spec_folders = [:units, :smoke_test]

desc "Run all tests"
task :tests do
  spec_folders.each do |folder| 
    echo_banner("Rspec #{folder} examples")
    Rake::Task["spec:#{folder}"].invoke  
  end
  # no real meaningful cuc tests yet 
  # echo_banner("Cucumber Features")
  # Rake::Task["cuc:all"].invoke  
end

desc "Remove example files generated from examples"

task :sweep do
  echo_banner "Removing files generated by examples"
  %w{
      examples/atlatl/pi.wav
      examples/chuck/simple_record.wav
      examples/lilypond/temp.ly
      examples/lilypond/temp.pdf
      examples/lilypond/temp.ps
  }.each do |file|
      path =  "#{PROJECT_ROOT}/#{file}"
      
      if File.exist?(path)
        puts "removing #{path}"
        system "rm #{path}"
      end 
  end 
  
  puts "\n\n" 
end

desc "Prints out a readable spec including rspec examples and cucumber feature steps"
task :readable_spec do
  echo_banner("RSpec Examples")
  spec_folders.each do |folder| 
    Rake::Task["spec:#{folder}_doc"].invoke  
  end 
  echo_banner("Cucumber Features")
  Rake::Task["cuc:all_pretty"].invoke  
end

namespace :spec do
  spec_folders.each do |sub|
    desc "Run the code examples in spec/#{sub}"
    Spec::Rake::SpecTask.new("#{sub}") do |t|
      t.spec_opts = ['--options', "\"#{PROJECT_ROOT}/spec/spec.opts\""]
      file_list = FileList["spec/#{sub}/*_spec.rb"] 
      t.spec_files = file_list
    end

    desc "Print Specdoc for spec/#{sub}_doc"
    Spec::Rake::SpecTask.new("#{sub}_doc") do |t| 
      t.spec_opts = ["--format", "specdoc", "--dry-run"]
      t.spec_files = FileList["spec/#{sub}/*_spec.rb"]
    end 
  end
end

namespace :cuc do
  desc "run cucumber specs"
  task :all do
    system "cucumber --format progress" 
  end
  desc "run cucumber specs and show readable steps" 
  task :all_pretty do
    system "cucumber -f pretty"
  end
end

task :banner, :text do |t, args|
  echo_banner(args[:text])
end

def echo_banner(text)
  hr = "\n----------------------------------------------------------\n"
  result = hr + text + hr 
  system "echo '#{result}'"
end
