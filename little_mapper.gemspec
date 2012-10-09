# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'little_mapper/version'

Gem::Specification.new do |gem|
  gem.name          = "little_mapper"
  gem.version       = LittleMapper::VERSION
  gem.authors       = ["Simon Robson"]
  gem.email         = ["shrobson@gmail.com"]
  gem.description   = %q{Simple, ActiveRecord-backed data mapper / repository}
  gem.summary       = %q{Simple, ActiveRecord-backed data mapper / repository}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency('sqlite3')
  gem.add_development_dependency('activerecord')
end
