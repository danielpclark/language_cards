# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'language_cards/version'

Gem::Specification.new do |spec|
  spec.name          = 'language_cards'
  spec.version       = LanguageCards::VERSION
  spec.authors       = ['Daniel P. Clark']
  spec.email         = ['6ftdan@gmail.com']

  spec.summary       = %q{Terminal flashcard game for learning languages with foreign scripts.}
  spec.description   = %q{Flashcard game for language learning: Japanese (kana, JLPT N5-N1 kanji and vocabulary), Chinese (HSK 1-4), Korean, Russian, Arabic, Hindi and many more. Make your own cards or translations as well.}
  spec.homepage      = 'http://github.com/danielpclark/language_cards'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = ['language_cards']
  spec.require_paths = ['lib','cards']

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'highline', '>= 2.0', '< 4'
  spec.add_dependency 'i18n', '>= 1.0', '< 2'
  spec.add_dependency 'slop', '~> 4.6'
  spec.add_development_dependency 'bundler', '>= 1.13'
  spec.add_development_dependency 'rake', '>= 12.3'
  spec.add_development_dependency 'minitest', '~> 5.10'
end
