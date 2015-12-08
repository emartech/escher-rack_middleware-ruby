module Escher::RackMiddleware::IncludePath

  require 'escher/rack_middleware/include_paths/helper'
  def self.extended(klass)
    klass.__send__(:include, self::Helper)
  end

  def add_include_paths(*paths)
    included_paths.push(*paths)
  end

  alias add_include_path add_include_paths

  def included_paths
    @included_paths ||= []
  end

end
