# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wiselinks/version'

Gem::Specification.new do |gem|
  gem.name          = 'wiselinks'
  gem.version       = Wiselinks::Version::STRING
  gem.authors       = ['Igor Alexandrov', 'Alexey Solilin', 'Julia Egorova', 'Alexandr Borisov']
  gem.email         = 'igor.alexandrov@gmail.com'
  gem.summary       = 'Wiselinks makes following links and submitting some forms in your web application smarter and faster'
  gem.homepage      = 'http://github.com/igor-alexandrov/wiselinks'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files | grep -v 'build/*'`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock', '~> 1.9.0'
  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'faker'
  gem.add_development_dependency 'capybara'

  gem.add_development_dependency 'rails', '~> 3.2.13'
  gem.add_development_dependency 'coffee-rails'

  gem.add_development_dependency 'closure-compiler'
  gem.add_development_dependency 'coffeelint'
end