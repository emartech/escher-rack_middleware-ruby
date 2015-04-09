module Escher::RackMiddleware::Authenticator

  require 'escher/rack_middleware/authenticator/helper'
  def self.extended(klass)
    klass.__send__(:include,self::Helper)
  end

  def add_escher_authenticator(&escher_instance_initializer)
    escher_authenticators.push(escher_instance_initializer)
  end

  def escher_authenticators
    @escher_authenticators ||= []
  end

end
