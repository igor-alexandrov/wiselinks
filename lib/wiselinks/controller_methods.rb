module Wiselinks
  module ControllerMethods

    def self.included(base)
      base.helper_method :wiselinks_title
      base.helper_method :wiselinks_description
      base.helper_method :wiselinks_canonical
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

    def wiselinks_description(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("description: #{value}")
        self.response.headers['X-Wiselinks-Description'] = URI.encode(value)
      end
    end

    def wiselinks_canonical(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("canonical: #{value}")
        self.response.headers['X-Wiselinks-Canonical'] = URI.encode(value)
      end
    end

    def set_wiselinks_url
      # self.response.headers['X-Wiselinks-Url'] = request.env['REQUEST_URI'] if self.request.wiselinks?
      self.response.headers['X-Wiselinks-Url'] = request.url if self.request.wiselinks?
    end
  end
end
