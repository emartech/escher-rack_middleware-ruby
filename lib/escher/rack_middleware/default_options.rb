module Escher::RackMiddleware::DefaultOptions

  protected



  def default_options
    {
        :logger => Escher::RackMiddleware.logger,
        :excluded_paths => Escher::RackMiddleware.excluded_paths,
        :included_paths => Escher::RackMiddleware.included_paths,
        :escher_authenticators => Escher::RackMiddleware.escher_authenticators,
        :credentials => Escher::RackMiddleware.credentials
    }
  end

end
