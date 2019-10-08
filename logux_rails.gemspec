# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logux/version'

Gem::Specification.new do |spec|
  spec.name          = 'logux_rails'
  spec.version       = Logux::VERSION
  spec.authors       = ['WildDima']
  spec.email         = ['dtopornin@gmail.com']

  spec.summary       = 'Logux client for rails'
  spec.description   = 'Logux client for rails'
  spec.homepage      = 'https://github.com/logux'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize'
  spec.add_dependency 'configurations'
  spec.add_dependency 'nanoid'
  spec.add_dependency 'rails', '>= 5.0', '< 6.1'
  spec.add_dependency 'rest-client'
  spec.add_development_dependency 'appraisal', '~> 2.2'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'combustion', '~> 1.1.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-live_controllers'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop', '~> 0.60.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.27.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webmock'
end
