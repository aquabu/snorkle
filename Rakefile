require File.expand_path(File.dirname(__FILE__)) + '/config/init.rb'
task :default => ["spec:units"]

require 'rake/testtask'
require 'spec/rake/spectask'

namespace :spec do
  desc "Print Specdoc for all specs"
  Spec::Rake::SpecTask.new(:doc) do |t| 
    # t.spec_opts = ["--format", "specdoc", "--dry-run"]
    t.spec_files = FileList['spec/**/*_spec.rb']
  end 

  [:units].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    Spec::Rake::SpecTask.new(sub) do |t|
      t.spec_opts = ['--options', "\"#{PROJECT_ROOT}/spec/spec.opts\""]
      file_list = FileList['spec/**/*_spec.rb'] 
      t.spec_files = file_list 
    end
  end
end
