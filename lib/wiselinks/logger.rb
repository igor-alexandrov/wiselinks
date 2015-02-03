module Wiselinks
  module Logger
    def logger
      @logger ||= Wiselinks.options[:logger] || ::Logger.new(STDOUT)
    end

    def log(message)
      self.logger.debug("  [wiselinks] #{message}")
    end
  end
end
