require 'language_cards/models/grapheme'
require 'language_cards/grapheme_builder'
require 'language_cards/modes/typing_practice'
require 'language_cards/modes/translate'

module LanguageCards
  class CardSet
    attr_reader :graphemes
    def initialize(grapheme_hash)
      @graphemes = GraphemeBuilder.(grapheme_hash)
    end

    def sample
      @graphemes.sample
    end

    def mode(mode)
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
