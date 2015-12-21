# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'payoneer-ruby'
  spec.version       = '0.2.0'
  spec.authors       = ['Chris Estreich']
  spec.email         = ['chris@tophatter.com']

  spec.summary       = 'Ruby bindings for the Payoneer API.'
  spec.description   = 'Payoneer provides businesses with international money transfer services and global payments.'
  spec.homepage      = 'https://github.com/cte/payoneer-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'

  spec.add_dependency 'rest-client'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
end
