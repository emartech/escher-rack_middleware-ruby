require 'escher/rack_middleware'
version_file_path = File.join(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))),'VERSION')
Escher::RackMiddleware::VERSION = File.read(version_file_path).strip