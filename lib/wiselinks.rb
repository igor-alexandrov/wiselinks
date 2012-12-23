require 'wiselinks/request'
require 'wiselinks/headers'
require 'wiselinks/helpers'

require 'wiselinks/logger'

require 'wiselinks/rails' if defined?(::Rails)

module Wiselinks
  extend Logger

  DEFAULTS = {    
    :assets_digest => nil,
    :logger => nil
  }

  def self.options
    @options ||= DEFAULTS.dup
  end

  def self.options=(value)
    @options = value
  end
end
