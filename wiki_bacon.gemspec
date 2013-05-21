# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wiki_bacon/version'

Gem::Specification.new do |gem|
  gem.name          = "wiki_bacon"
  gem.version       = WikiBacon::VERSION
  gem.authors       = ["Jacob Robertson"]
  gem.email         = ["g.jacob.robertson@gmail.com"]
  gem.description   = %q{BACON!}
  gem.summary       = %q{BACON!}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
