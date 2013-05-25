# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_store/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_store"
  spec.version       = HashStore::VERSION
  spec.authors       = ["M.Iwasaki(Curi)"]
  spec.email         = ["curi1119@gmail.com"]
  spec.description   = %q{}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'multi_json'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'mock_redis'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord'
end
