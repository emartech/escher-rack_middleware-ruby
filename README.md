# Escher::RackMiddleware

Rack Middleware for ease of use escher authentication for your application

## Installation

Add this line to your application's Gemfile:

    gem 'escher-rack_middleware'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install escher-rack_middleware

## Usage

```ruby


require 'escher/rack_middleware'
Escher::RackMiddleware.config do |c|

  # the default logger use the ruby core logger with STDOUT
  c.logger= some_logger_instance

  # for read more about escher auth object initialization please visit escherauth.io
  c.add_escher_authenticator{ Escher::Auth.new( CredentialScope, AuthOptions ) }

  # this will be triggered every time a request hit your appication
  c.add_credential_updater{ Escher::Keypool.new.get_key_db }

  # this help you exclude path(s) if you dont want require authorization for every endpoint
  c.add_exclude_path(/^\/*monitoring\//)

end

use Escher::RackMiddleware
run YourAwesomeApplication

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/escher-rack_middleware/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
