# -*- coding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_store/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_store"
  spec.version       = HashStore::VERSION
  spec.authors       = ["M.Iwasaki(Curi)"]
  spec.email         = ["curi1119@gmail.com"]
  spec.description   = <<-EOS
    HashStore store RubyHash into Redis as JSON.
    Automatically add redis commands(GET,SET,DEL,EXITS) methods to your class.
    HashStore was designed to work with ActiveRecord, but also work with Non-ActiveRecord Class.
  EOS

  spec.summary       = %q{HashStore store RubyHash into Redis as JSON.}
  spec.homepage      = "https://github.com/curi1119/hash_store"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'oj'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'mock_redis'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'coveralls'
end
