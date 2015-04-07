module Escher::RackMiddleware::ExcludePath::Helper

  def excluded_paths
    @excluded_paths ||= self.class.excluded_paths.dup
  end

  def excluded_path?(path)
    excluded_paths.any? do |matcher|
      if matcher.is_a?(Regexp)
        !!(path =~ matcher)
      else
        path == matcher.to_s
      end
    end
  end

end