module Wiselinks
  module Rendering    
    
    def self.included(base)            
      base.alias_method_chain :render, :wiselinks
    end

  protected

    def render_with_wiselinks(options = {}, *args, &block)      
      if self.request.wiselinks?        
        self.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
        self.headers['Pragma'] = 'no-cache'

        if self.request.wiselinks_partial?
          Wiselinks.log("processing partial request")
          options[:partial] ||= action_name
        else
          Wiselinks.log("processing template request")
          
          if Wiselinks.options[:layout] != false
            options[:layout] = self.wiselinks_layout 
          end
        end

        if Wiselinks.options[:assets_digest].present?
          Wiselinks.log("assets digest #{Wiselinks.options[:assets_digest]}")

          self.headers['X-Wiselinks-Assets-Digest'] = Wiselinks.options[:assets_digest]          
        end
      end

      self.render_without_wiselinks(options, args, &block)
    end
  end
end
