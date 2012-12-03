require 'headers'

module Wiselinks
  class Engine < ::Rails::Engine

    initializer "wiselinks.register"  do
      ActionController::Base.send :include, Headers
    end
    
  end
end
