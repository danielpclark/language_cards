require 'language_cards/models/card'

module LanguageCards
  module CardSetBuilder
    def card_set_builder(translation_cards = {})
      translation_cards.each_with_object([]) do |(key, value), memo|
        memo << Card.new(key, value)
      end
    end
  end
end
