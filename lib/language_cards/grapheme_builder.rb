require 'language_cards/models/grapheme'

module LanguageCards
  module GraphemeBuilder
    def self.call(translation_graphemes = {})
      translation_graphemes.each_with_object([]) do |(key, value), memo|
        memo << Grapheme.new(key, value)
      end
    end
  end
end
