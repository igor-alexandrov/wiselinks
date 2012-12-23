module Wiselinks
  module Rails
    class Engine < ::Rails::Engine
      initializer 'wiselinks.register_logger' do        
        Wiselinks.options[:logger] = ::Rails.logger
      end

      initializer "wiselinks.register_extensions"  do
        ActionDispatch::Request.send :include, Request
        ActionController::Base.send :include, Headers
        ActionView::Base.send :include, Helpers        
      end    

      initializer "wiselinks.register_assets_digest"  do
        if ::Rails.application.config.assets.digest && ::Rails.application.config.assets.digests.present?
          Wiselinks.options[:assets_digest] ||= Digest::MD5.hexdigest(::Rails.application.config.assets.digests.values.join)
        end
      end
    end
  end
end
