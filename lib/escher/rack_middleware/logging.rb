module Escher::RackMiddleware::Logging

  require 'escher/rack_middleware/logging/helper'

  def self.extended(klass)
    klass.__send__(:include,LoggingHelper)
  end

  def logger=(logger)
    @logger=logger
  end

  def logger
    @logger ||= -> {
      require 'logger'
      Logger.new(STDOUT)
    }.call
  end

end