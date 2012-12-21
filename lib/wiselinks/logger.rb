module Wiselinks
  module Logger
    extend self

    def self.logger
      @logger ||= ::Logger.new(STDOUT)
    end

    def logger=(logger)
      @logger = logger
    end

    def log(message)
      logger.info("[wiselinks] #{message}")
    end
  end
end