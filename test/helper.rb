require 'rubygems'
require 'bundler'

ENV['RAILS_ENV'] = 'test'
require "dummy/config/environment"

require "rails/test_help"

require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'wiselinks'