module Escher::RackMiddleware::Logging::Helper

  def logger
    self.class.logger
  end

  # default log object to be used if further verbosity required
  def default_log_message(request_env)
    {}
  end

  def log_message(request_env)

    message = default_log_message(request_env)

    regexp = /^escher/
    request_env.select { |k, v| k.to_s =~ regexp }.each do |k, v|
      message[k.to_s.gsub(regexp, '')]= request_env[v]
    end

    rack_env = Rack::Request.new(request_env)

    message['request.host'] = rack_env.host
    message['request.method'] = rack_env.request_method
    message['request.endpoint'] = rack_env.path_info
    message['requester.address'] = rack_env.ip

    message['escher.request.status'] = if request_env['escher.error']
                                         'failed'
                                       else
                                         'succeeded'
                                       end

    return message.inspect

  end

end