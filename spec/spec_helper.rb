require 'simplecov'
class SimpleCov::Formatter::HTMLFormatter
  def output_message(result)
    "Coverage: #{result.covered_percent.round(2)}% (#{result.covered_lines}/#{result.total_lines} LOC)"
  end
end
SimpleCov.start

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
