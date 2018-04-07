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
      case mode
      when :translate
        Modes::Translate.new(self)
      when :typing_practice
        Modes::TypingPractice.new(self) 
      else
        raise "Invalid Game Mode!"
      end
    end

    # So as to not interfere with menu naming as this is not meant to
    # be displayed as a string.
    def to_s
      ""
    end

    def label
      []
    end
  end
end
