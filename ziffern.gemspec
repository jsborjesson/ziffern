# coding: utf-8

Gem::Specification.new do |gem|
  gem.name          = "ziffern"
  gem.version       = "2.0.0.alpha"
  gem.author        = "Jimmy Börjesson"
  gem.email         = "lagginglion@gmail.com"
  gem.summary       = "Converts numbers to text, in German."
  gem.homepage      = "https://github.com/alcesleo/ziffern"
  gem.license       = "MIT"

  gem.required_ruby_version = '>= 2.0'

  gem.files         = Dir['Rakefile', 'README*', 'LICENSE*', '{lib,spec}/**/*']
  gem.test_files    = Dir['spec/**/*']
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.6"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
end
