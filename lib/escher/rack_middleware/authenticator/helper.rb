module Escher::RackMiddleware::Authenticator::Helper

  def escher_authenticators
    self.class.escher_authenticators
  end

  def authorized?(request_env)
    escher_authenticators.any? { |instance| authorized_with?(instance, request_env) }
  end

  def authorized_with?(escher_authenticator, request_env)

    request_env['escher.request.api_key_id'] = escher_authenticator.authenticate(
        Rack::Request.new(request_env),credentials
    )

    requester_succeed_log_msg = [
        request_env['escher.request.api_key_id'],
        request_env['REQUEST_URI']
    ].join(' => ')

    logger.debug("authentication succeeded!(#{requester_succeed_log_msg})")

    true
  rescue Escher::EscherError => ex

    logger.debug("authentication failed!(#{ex.message})")

    false

  end

end