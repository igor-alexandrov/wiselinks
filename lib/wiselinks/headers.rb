module Wiselinks
  module Headers    

  protected

    def wiselinks_layout
      'wiselinks'
    end

    def render(options = {}, *args, &block)
      if self.request.wiselinks?
        if self.request.wiselinks_partial?
          options[:partial] ||= action_name
        else
          options[:layout] = self.wiselinks_layout        
        end
      end

      super
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