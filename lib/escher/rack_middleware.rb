require 'escher'
class Escher::RackMiddleware

  require 'escher/rack_middleware/version'
  require 'escher/rack_middleware/logging'
  require 'escher/rack_middleware/credential'
  require 'escher/rack_middleware/exclude_path'
  require 'escher/rack_middleware/include_path'
  require 'escher/rack_middleware/authenticator'

  extend Logging
  extend Credential
  extend ExcludePath
  extend IncludePath
  extend Authenticator

  def initialize(app)
    @app = app
  end

  def call(request_env)
    if authorize_path?(request_env['REQUEST_URI'])
      return unauthorized_response unless authorized?(request_env)
    end

    @app.call(request_env)
  end

  protected

  def authorize_path?(path)
    # if no included or excluded paths are defined in config, default to all
    # routes being authorized
    return true if excluded_paths.none? && included_paths.none?

    return !excluded_path?(path) if excluded_paths.any?
    included_path?(path) if included_paths.any?
  end

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

    # Makes no sense allow include and exclude paths. By default all routes are
    # authorize and we can define excluded paths, or we allow to either include
    # the paths we want to check (reverting that logic). Because of this check
    # if both included and excluded paths were defined in configuration
    # immediately after config block.
    if excluded_paths.any? && included_paths.any?
      fail "Configuration: Excluded and included paths are mutually exclusive."
    end
  end

end
