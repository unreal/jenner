# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenner/version'

Gem::Specification.new do |gem|
  gem.name          = "jenner"
  gem.version       = Jenner::VERSION
  gem.authors       = ["Jay Strybis"]
  gem.email         = ["jay.strybis@gmail.com"]
  gem.description   = %q{Jenner is an opinionated static site generator}
  gem.summary       = %q{Jenner is an opinionated static site generator}
  gem.homepage      = "http://github.com/unreal/jenner"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = ["jenner"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "haml", "~> 4.0.5"
  gem.add_dependency "liquid", "~> 2.6.1"
  gem.add_dependency "maruku", "~> 0.7.1"
  gem.add_dependency "mercenary", "~> 0.2.1"
  gem.add_dependency "sass", "~> 3.2.13"
  gem.add_development_dependency "test-unit", "~> 2.5.5"
end
