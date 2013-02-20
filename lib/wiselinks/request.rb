module Wiselinks
  module Request
    def wiselinks?
      self.headers['X-Wiselinks'].present?
    end

    def wiselinks_template?
      self.wiselinks? && self.headers['X-Wiselinks'] != 'partial'
    end

    def wiselinks_partial?
      self.wiselinks? && self.headers['X-Wiselinks'] == 'partial'
    end
  end
end

