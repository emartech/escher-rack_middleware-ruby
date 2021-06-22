# coding: utf-8
Gem::Specification.new do |spec|

  spec.name          = 'escher-rack_middleware'
  spec.version       = File.read(File.join(File.dirname(__FILE__),'VERSION'))
  spec.authors       = ['Adam Luzsi']
  spec.email         = ['aluzsi@emarsys.com']
  spec.summary       = %q{Escher authorization for rack based http servers}
  spec.description   = %q{Escher authorization for rack based http servers with ease in a form of middleware}
  spec.homepage      = 'https://github.com/emartech/escher-rack_middleware-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.2.20'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'rack'
  spec.add_dependency 'escher', '>= 0.3.3'

end
