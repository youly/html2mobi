# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html2mobi/version'

Gem::Specification.new do |spec|
  spec.name          = "html2mobi"
  spec.version       = Html2mobi::VERSION
  spec.authors       = ["youly"]
  spec.email         = ["youly001@gmail.com"]
  spec.summary       = %q{convert online html to mobi}
  spec.description   = %q{support sohu}
  spec.homepage      = "https://github.com/youly/html2mobi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "kindler", "~> 0.5.0"
  spec.add_dependency "nokogiri", "~> 1.6.3"
  spec.add_dependency "mail", "~> 2.6.3"
end
