# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'language_cards/version'

Gem::Specification.new do |spec|
  spec.name          = "language_cards"
  spec.version       = LanguageCards::VERSION
  spec.authors       = ["Daniel P. Clark"]
  spec.email         = ["6ftdan@gmail.com"]

  spec.summary       = %q{Flashcard game for language learning.}
  spec.description   = %q{Flashcard game for language learning. Make your own cards or translations as well.}
  spec.homepage      = "http://github.com/danielpclark/language_cards"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = ['language_cards']
  spec.require_paths = ["lib","cards"]

  spec.add_dependency "highline", "~> 1.7"
  spec.add_dependency "i18n", "~> 0.7"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.10"
end
