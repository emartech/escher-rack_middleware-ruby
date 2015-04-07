module Escher::RackMiddleware::ExcludePath

  require 'escher/rack_middleware/exclude_paths/helper'
  def self.extended(klass)
    klass.__send__(:include,self::Helper)
  end

  def add_exclude_paths(*paths)
    excluded_paths.push(*paths)
  end

  alias add_exclude_path add_exclude_paths

  def excluded_paths
    @excluded_paths ||= []
  end

end