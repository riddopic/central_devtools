# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'central/devtools/version'

Gem::Specification.new do |gem|
  gem.name             = 'central-devtools'
  gem.version          = Central::Devtools::VERSION
  gem.authors          = ['Stefano Harding']
  gem.email            = ['riddopic@gmail.com']
  gem.summary          = 'Shared development tasks for project Central Machine'
  gem.homepage         = 'https://github.com/central/central-devtools'
  gem.license          = 'Apache-2.0'

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths    = ['lib']
  gem.extra_rdoc_files = ['LICENSE', 'README.md']

  gem.required_ruby_version = '>= 2.1'

  gem.add_runtime_dependency 'tty'
  gem.add_runtime_dependency 'inifile'
  gem.add_runtime_dependency 'colorize'

  gem.add_runtime_dependency 'procto', '~> 0.0.x'
  gem.add_runtime_dependency 'anima', '~> 0.3.x'
  gem.add_runtime_dependency 'concord'
  gem.add_runtime_dependency 'adamantium', '~> 0.2.x'
  gem.add_runtime_dependency 'rspec', '~> 3.4.0'
  gem.add_runtime_dependency 'rspec-core', '~> 3.4.0'
  gem.add_runtime_dependency 'rspec-its', '~> 1.2.0'
  gem.add_runtime_dependency 'rake', '~> 10.4.2'
  gem.add_runtime_dependency 'yard', '~> 0.8.7.6'
  gem.add_runtime_dependency 'flay', '~> 2.6.1'
  gem.add_runtime_dependency 'flog', '~> 4.3.2'
  gem.add_runtime_dependency 'reek', '~> 3.7.0'
  gem.add_runtime_dependency 'rubocop', '~> 0.35.1'
  gem.add_runtime_dependency 'simplecov', '~> 0.10.0'
  gem.add_runtime_dependency 'yardstick', '~> 0.9.9'
  gem.add_runtime_dependency 'mutant', '~> 0.8.9'
  gem.add_runtime_dependency 'mutant-rspec', '~> 0.8.8'
end
