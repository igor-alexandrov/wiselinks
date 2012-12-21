require 'wiselinks/headers'
require 'wiselinks/request'
require 'wiselinks/logger'

module Wiselinks
  class Engine < ::Rails::Engine
    initializer 'wiselinks.setup_logger' do
      Wiselinks::Logger.logger = Rails.logger
    end

    initializer "wiselinks.register"  do
      ActionController::Base.send :include, Headers
      ActionDispatch::Request.send :include, Request
    end    
  end
end
