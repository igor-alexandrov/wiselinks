module Wiselinks
  module ControllerMethods    
    
    def self.included(base)      
      base.helper_method :wiselinks_title      

      base.before_filter :set_wiselinks_url
    end

  protected

    def wiselinks_layout
      'wiselinks'
    end

    def wiselinks_title(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("title: #{value}")        
        self.response.headers['X-Wiselinks-Title'] = URI.encode(value)
      end
    end

    def set_wiselinks_url      
      self.response.headers['X-Wiselinks-Url'] = request.url if self.request.wiselinks?
    end    

    def wiselinks_request?
      Wiselinks::Logger.log "DEPRECATION WARNING: Method `wiselinks_request?` is deprecated. Please use `request.wiselinks?` instead."

      self.request.wiselinks?
    end

    def wiselinks_template_request?
      Wiselinks::Logger.log "DEPRECATION WARNING: Method `wiselinks_template_request?` is deprecated. Please use `request.wiselinks_template?` instead."

      self.request.wiselinks_template?
    end

    def wiselinks_partial_request?
      Wiselinks::Logger.log "DEPRECATION WARNING: Method `wiselinks_partial_request?` is deprecated. Please use `request.wiselinks_partial?` instead."

      self.request.wiselinks_partial?
    end
  end
end