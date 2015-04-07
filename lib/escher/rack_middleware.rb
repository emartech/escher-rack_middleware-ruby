require 'escher'
class Escher::RackMiddleware

  require 'escher/rack_middleware/version'
  require 'escher/rack_middleware/logging'
  require 'escher/rack_middleware/credential'
  require 'escher/rack_middleware/exclude_path'
  require 'escher/rack_middleware/authenticator'

  extend Logging
  extend Credential
  extend ExcludePath
  extend Authenticator

  def initialize(app)
    @app = app
  end

  def call(request_env)

    unless excluded_path?(request_env['REQUEST_URI'])
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

  def env_dump_string(request_env)
    require 'yaml' unless defined?(YAML)
    YAML.dump(request_env)
  end

  def self.config(&block)
    block.call(self)
  end

end