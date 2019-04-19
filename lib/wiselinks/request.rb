module Wiselinks
  module Request
    def self.included(base)
      base.send :prepend, Wiselinks::Request
    end

    def referer
      self.headers['X-Wiselinks-Referer'] || super
    end

    def referrer
      self.referer
    end

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

