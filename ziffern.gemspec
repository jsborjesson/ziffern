# coding: utf-8

Gem::Specification.new do |gem|
  gem.name          = "ziffern"
  gem.version       = "1.2.0"
  gem.author        = "Jimmy Börjesson"
  gem.email         = "jimmy.borjesson@gmail.com"
  gem.summary       = "Converts numbers to text, in German."
  gem.homepage      = "https://github.com/jsborjesson/ziffern"
  gem.license       = "MIT"

  gem.files         = %w[README.md ziffern.rb ziffern_spec.rb]
  gem.test_files    = %w[ziffern_spec.rb]
  gem.require_paths = ["."]

  gem.add_development_dependency "bundler", "~> 2.4"
  gem.add_development_dependency "rake", "~> 13.0"
  gem.add_development_dependency "rspec", "~> 3.4"
  gem.add_development_dependency "rubocop", "~> 1.69"
end
