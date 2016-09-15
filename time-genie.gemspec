# coding: utf-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'time-genie/version'

Gem::Specification.new do |s|
  s.name        = 'time-genie'
  s.version     = TimeGenie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['David FRANCOIS']
  s.email       = ['david@paygun.fr']
  s.homepage    = 'https://paygun.fr'
  s.summary     = 'A time span management library'
  s.description = 'Time-Genie provides utilities to manage time spans, intersect them, and manage temporal inclusions of model hierarchies'
  s.licenses    = ['MIT']

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'

  s.require_path = 'lib'
end

