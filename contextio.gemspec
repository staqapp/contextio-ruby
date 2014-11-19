# -*- encoding: utf-8 -*-

require File.expand_path('../lib/contextio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "contextio-modernfaraday"
  gem.version       = ContextIO.version
  gem.summary       = 'Provides interface to Context.IO - with more relaxed faraday dependency'
  gem.description   = 'Provides Ruby interface to Context.IO - with more relaxed faraday dependency'
  gem.license       = 'MIT'
  gem.authors       = ['Ben Hamill']
  gem.email         = %w(ben@benhamill.com)
  gem.homepage      = 'https://github.com/contextio/contextio-ruby#readme'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'faraday', ['>= 0.8.0', '< 0.10.0']
  gem.add_dependency 'faraday_middleware', '~> 0.9.0'
  gem.add_dependency 'simple_oauth', '~> 0.2.0'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rubygems-tasks',  '~> 0.2'
  gem.add_development_dependency 'rspec',           '~> 2.14'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'pry-doc'
  gem.add_development_dependency 'webmock'
end
