module Escher::RackMiddleware::DefaultOptions

  protected

  def default_options
    Escher::RackMiddleware.instance_variables.reduce({}) do |options, name|
      options[name.to_s.sub(/^@/, '').to_sym]= Escher::RackMiddleware.instance_variable_get(name)

      options
    end
  end

end
