require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = "ziffern_spec.rb"
end
task default: :spec
