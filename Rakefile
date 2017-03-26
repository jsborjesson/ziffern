require "bundler/gem_tasks"

task default: [:spec, :style]

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = "ziffern_spec.rb"
end

require "rubocop/rake_task"
RuboCop::RakeTask.new(:style) do |t|
  t.options = ["--display-cop-names"]
end
