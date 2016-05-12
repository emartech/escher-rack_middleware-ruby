require 'rspec'
require 'rack'
$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), 'lib'))
require 'escher/rack_middleware'

CREDENTIAL_SCOPE = 'a/b/c'

AUTH_OPTIONS = {
    algo_prefix: 'AWS',
    vendor_key: 'AWS',
    auth_header_name: 'X-AWS-Auth',
    date_header_name: 'X-AWS-Date'
}

require 'logger'
SPEC_LOGGER = Logger.new($stdout)
SPEC_LOGGER.level= Logger::Severity::UNKNOWN

Escher::RackMiddleware.config do |global_settings|

  global_settings.logger = SPEC_LOGGER

  global_settings.add_exclude_path '/not_protected', '/endpoint', /^\/unprotected_namespace/
  global_settings.add_include_path '/protected', '/endpoint_path', '/unprotected_namespace/except_this_endpoint_which_is_included'

  global_settings.add_credential_updater { {"a_b_v1" => "development_secret"} }
  global_settings.add_escher_authenticator { Escher::Auth.new(CREDENTIAL_SCOPE, AUTH_OPTIONS) }

end


module SpecRackHelpers

  def escher_signed_get(uri, opts={})

    request_hash = {}
    request_hash[:method] = 'GET'
    request_hash[:uri] = uri
    request_hash[:headers] = ({'host' => 'localhost'}.merge(opts[:headers] || {})).to_a
    request_hash[:body] = opts[:body]

    client = {:api_key_id => "a_b_v1", :api_secret => "development_secret"}
    escher.sign!(request_hash, client)

    env = {}
    request_hash[:headers].each do |key, value|
      env["HTTP_#{key.to_s.upcase}"]= value
    end

    env[:input]= request_hash[:body]
    env['REQUEST_URI'] = uri
    env['REQUEST_PATH'] = uri
    env['REQUEST_METHOD'] = 'GET'

    get(uri, env)

  end

  def escher
    Escher::Auth.new(CREDENTIAL_SCOPE, AUTH_OPTIONS)
  end

  def get(*args)
    ::Rack::MockRequest.new(app).get(*args)
  end

  def app
    builder = Rack::Builder.new
    builder.use(escher_rack_middleware)
    builder.run(rack_app)
    builder.to_app
  end

  def rack_app
    Proc.new do |env|

      resp = Rack::Response.new
      case env[::Rack::PATH_INFO]

        when '/'
          resp.write('default')

        when '/protected', '/endpoint_path', '/unprotected_namespace/except_this_endpoint_which_is_included'
          resp.write('included')

        when '/not_protected', '/endpoint', /^\/unprotected_namespace/
          resp.write('excluded')

        else
          resp.status = 404

      end
      resp.finish

    end
  end

end

RSpec.configuration.include(SpecRackHelpers)