require 'escher'
class Escher::RackMiddleware

  require 'escher/rack_middleware/version'
  require 'escher/rack_middleware/logging'
  require 'escher/rack_middleware/credential'
  require 'escher/rack_middleware/exclude_path'
  require 'escher/rack_middleware/include_path'
  require 'escher/rack_middleware/authenticator'
  require 'escher/rack_middleware/default_options'

  extend Logging
  extend Credential
  extend ExcludePath
  extend IncludePath
  extend Authenticator
  include DefaultOptions

  def initialize(app,options={})
    @app = app
    @options = default_options.merge(options)
  end

  def call(request_env)
    if authorize_path?(::Rack::Utils.clean_path_info(request_env[::Rack::PATH_INFO]))
      return unauthorized_response unless authorized?(request_env)
    end

    @app.call(request_env)
  end

  protected

  def unauthorized_response
    response = Rack::Response.new
    response.write 'Unauthorized'
    response.status = 401
    response.finish
  end

  def self.config(&block)
    block.call(self)
  end

  def authorize_path?(path)
    case true

      when paths_of(:included_paths, include: path)
        true

      when paths_of(:excluded_paths, include: path)
        false

      else
        true

    end
  end

  def paths_of(option_key, h)
    path = h[:include]
    @options[option_key].any? do |matcher|
      if matcher.is_a?(Regexp)
        !!(path =~ matcher)
      else
        path == matcher.to_s
      end
    end
  end


end
