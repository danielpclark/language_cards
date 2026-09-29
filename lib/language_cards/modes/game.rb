
module LanguageCards
  module Modes
    class Game
      def initialize card_set
        @card_set = card_set.cards
        @index = 0
        @current = nil
      end

      def current
        @current or raise "Current flash card not yet set!"
      end

      # Picks a random card, avoiding the same card twice in a row.
      # @return self
      def sample
        choices = @card_set.length > 1 ? @card_set - [@current] : @card_set
        @current = choices.sample
        self
      end

      # Iterator for cycling through all translations sequentially.
      # @return Grapheme Returns a random grapheme
      def next
        value = @card_set[@index % @card_set.length]
        @index += 1
        @current = value
      end

      private
      # Makes comparisons forgiving of surrounding/repeated whitespace and of
      # differing Unicode compositions (e.g. pinyin tone marks).
      def normalize(text)
        text = text.to_s
        text = text.unicode_normalize(:nfc) rescue text
        text.strip.squeeze(' ')
      end
    end
  end
end
