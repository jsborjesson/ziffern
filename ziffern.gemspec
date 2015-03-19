# coding: utf-8

Gem::Specification.new do |gem|
  gem.name          = "ziffern"
  gem.version       = "1.1.4"
  gem.author        = "Jimmy Börjesson"
  gem.email         = "lagginglion@gmail.com"
  gem.summary       = "Converts numbers to text, in German."
  gem.homepage      = "https://github.com/alcesleo/ziffern"
  gem.license       = "MIT"

  gem.files         = %w{ README.md ziffern.rb ziffern_spec.rb }
  gem.test_files    = %w{ ziffern_spec.rb }
  gem.require_paths = ["."]

  gem.add_development_dependency "bundler", "~> 1.6"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
end
