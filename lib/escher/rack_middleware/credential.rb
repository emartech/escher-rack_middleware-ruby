module Escher::RackMiddleware::Credential

  require 'escher/rack_middleware/credential/helper'
  def self.extended(klass)
    klass.__send__(:include,self::Helper)
  end

  def add_credential(key,value)
    raw_credentials.merge!(key => value)
  end

  def add_credential_updater(&block)
    raise(ArgumentError,'block was not given') unless block_given?
    @credential_callback = block
  end

  def credentials
    new_credentials = credential_callback.respond_to?(:call) && credential_callback.call
    if new_credentials.is_a?(Hash)
      raw_credentials.merge(new_credentials)
    else
      raw_credentials
    end
  end

  protected

  def raw_credentials
    @credentials ||= {}
  end

  def credential_callback
    @credential_callback ||= Proc.new{{}}
  end

end