require 'layout'

module Wiselinks
  class Engine < ::Rails::Engine

    initializer "wiselinks.register"  do
      ActionController::Base.send :include, Layout
    end
    
  end
end
