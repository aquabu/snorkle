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

namespace :spec do
  desc "Print Specdoc for all specs"
  Spec::Rake::SpecTask.new(:doc) do |t| 
    t.spec_opts = ["--format", "specdoc", "--dry-run"]
    t.spec_files = FileList['spec/**/*_spec.rb']
  end 

  [:units].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    Spec::Rake::SpecTask.new(sub) do |t|
      t.spec_opts = ['--options', "\"#{PROJECT_ROOT}/spec/spec.opts\""]
      file_list = FileList["spec/#{sub}/*_spec.rb"] 
      t.spec_files = file_list
    end
  end
end

namespace :cuc do
  desc "run cucumber specs"
  task :all do
    system "cucumber --format progress" 
  end
  
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
