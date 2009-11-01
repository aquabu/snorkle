require File.expand_path(File.dirname(__FILE__)) + '/config/init.rb'
task :default => [:tests]

require 'rake/testtask'
require 'spec/rake/spectask'

desc "Run all tests"
task :tests do
  echo_banner("RSpec Examples")
  Rake::Task["spec:units"].invoke  
  echo_banner("Cucumber Features")
  Rake::Task["cuc:all"].invoke  
end

desc "Prints out a readable spec including rspec examples and cucumber feature steps"
task :readable_spec do
  echo_banner("RSpec Examples")
  Rake::Task["spec:units_doc"].invoke  
  echo_banner("Cucumber Features")
  Rake::Task["cuc:all_pretty"].invoke  
end

namespace :spec do
  [:units].each do |sub|
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
