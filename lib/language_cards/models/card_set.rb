require 'language_cards/models/card'
require 'language_cards/card_set_builder'
require 'language_cards/modes/typing_practice'
require 'language_cards/modes/translate'

module LanguageCards
  class CardSet
    include CardSetBuilder
    attr_reader :cards
    def initialize(card_hash)
      @cards = card_set_builder(card_hash)
    end

    def game(mode)
      Modes.public_send mode, self
    rescue NoMethodError
      raise InvalidGameMode, "Invalid Game Mode!"
    end

    # So as to not interfere with menu naming as this is not meant to
    # be displayed as a string.
    def to_s
      ""
    end

    def label
      []
    end

    private
    class InvalidGameMode < StandardError; end
  end
end
