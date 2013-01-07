$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rails'
require 'wiselinks'
require 'rspec'
require 'webmock/rspec'

ENV['RAILS_ENV'] = 'test'
require "dummy/config/environment"

require 'capybara/rspec'
require 'capybara/rails'
Capybara.app = Dummy::Application

require 'factory_girl'
FactoryGirl.find_definitions