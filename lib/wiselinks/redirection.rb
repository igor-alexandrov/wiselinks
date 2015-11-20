module Wiselinks
  module Redirection

    def redirect_to(url = {}, response_status = {})
      wiselinks = response_status.delete(:wiselinks)
      wiselinks = (request.xhr? && !request.get?) if wiselinks.nil?

      if wiselinks
        response.content_type = Mime[:js]
      end

      return_value = super(url, response_status)

      if wiselinks
        self.status = 200
        self.response_body = "window.wiselinks.load('#{location}');"
      end

      return_value
    end

  end
end
