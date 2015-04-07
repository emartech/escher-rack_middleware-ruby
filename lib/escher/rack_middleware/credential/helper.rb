module Escher::RackMiddleware::Credential::Helper

  def credentials
    self.class.credentials
  end
  
end