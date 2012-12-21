module Wiselinks
  module Request
    def wiselinks?
      self.headers['X-Render'].present?
    end

    def wiselinks_template?
      self.wiselinks? && self.headers['X-Render'] != 'partial'
    end

    def wiselinks_partial?
      self.wiselinks? && self.headers['X-Render'] == 'partial'
    end
  end
end

