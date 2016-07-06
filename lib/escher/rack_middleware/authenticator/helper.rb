module Escher::RackMiddleware::Authenticator::Helper

  def escher_authenticators
    self.class.escher_authenticators
  end

  def authorized?(request_env)
    logger.warn('No Escher authenticator was found. Check your config!') if escher_authenticators.empty?
    escher_authenticators.any? { |instance_init| authorized_with?(instance_init.call, request_env) }
  end

  def authorized_with?(escher_authenticator, request_env)

    request_env['escher.request.api_key_id'] = escher_authenticator.authenticate(
        Rack::Request.new(request_env), credentials)

    request_env.delete('escher.error') rescue nil
    logger.debug(log_message(request_env))

    true

  rescue Escher::EscherError => ex

    request_env['escher.error'] = ex.message || ex.inspect
    logger.warn(log_message(request_env))

    false

  end

end
