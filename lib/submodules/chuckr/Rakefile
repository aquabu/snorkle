require 'rake'

task :default => ["spec:all"]

namespace :spec do
  desc 'run ALL specs'
  task(:all) { sh 'ruby spec/**_spec.rb' } # :all => [:vm, :shred, :runtime]
  
  desc 'run VM specs'
  task(:vm) { sh 'ruby spec/vm_spec.rb' }
  
  desc 'run Shred specs'
  task(:shred) { sh 'ruby spec/shred_spec.rb' }
  
  desc 'run RUNTIME specs'
  task(:runtime) { sh 'ruby spec/runtime/*_spec.rb' }
end

namespace :chuck do
  desc 'build & install bin/chuckr_bin'
  task :setup => [ :build, :install, :clean ]
  desc 'build vendor/chuck/chuck'
  task :build do
    makefile = "osx-intel" # osx-ppc, osx-ub, linux-oss, linux-jack, linux-alsa
    if ARGV[1] && args = ARGV[1].split("=") # rake chuck:setup env=linux-oss to overwrite default
      makefile = args.last if args.first == "env"
    end
    sh "cd vendor/chuck; make #{makefile}"
  end
  desc "install bin/chuckr_bin"
  task :install do
    build_path = File.dirname(__FILE__) + '/vendor/chuck/chuck'
    bin_path = File.dirname(__FILE__) + '/bin/chuckr_bin'
    if File.exists?(build_path)
      FileUtils.mv(build_path, bin_path)
      puts "\n\nCHUCKR_BIN is installed now!"
    else
      puts 'ERROR: vendor/chuck/chuck not found! something went wrong..'
    end
  end
  desc "clean vendor/chuck"
  task :clean do
    sh "cd vendor/chuck; make clean > /dev/null 2>&1"
    puts 'vendor/chuck clean again.'
  end
end