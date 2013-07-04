$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

ENV['RAILS_ENV'] = 'test'
require "dummy/config/environment"

require 'rspec/rails'
require 'webmock/rspec'
require 'wiselinks'

require 'coveralls'
Coveralls.wear!

require 'capybara/rspec'
require 'capybara/rails'
Capybara.app = Dummy::Application

require 'factory_girl'
FactoryGirl.find_definitions

RSpec::Matchers::define :have_meta do |name|
  match do |page|
    puts Capybara.string(page.body)
    Capybara.string(page.body).has_selector?(:xpath, "//head/meta[@name='#{name}']")
  end
end