module Wiselinks
  module Layout

    def wiselinks_layout
      'wiselinks'
    end

    def render(options = {}, *args, &block)
      if request.headers['X-Slide'].present?
        if request.headers['X-Slide'] == 'partial'
          options[:partial] ||= action_name
        else
          options[:layout] = self.wiselinks_layout        
        end
      end

      super
    end
  end
end