begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

import "tasks/sync.rake"

task :default => [:spec]
desc 'run Rspec specs'
task :spec do
  sh 'rspec'
end
