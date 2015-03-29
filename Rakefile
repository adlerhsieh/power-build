require "bundler/gem_tasks"

task :install do
  command = %x[cd ~/projects/power-build]
  command = %x[gem build power-build.gemspec]
  command = %x[cd ~/projects/power-build/pkg]
  command = %x[gem install power-build-0.0.1.gem]
end
