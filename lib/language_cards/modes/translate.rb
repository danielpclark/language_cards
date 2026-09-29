require 'language_cards/modes/game'
module LanguageCards
  module Modes
    def self.translate card_set
      Translate.new card_set
    end

    class Translate < Game
      def match? input
        answer = comparable(input)
        current.translation.any? {|value| comparable(value) == answer }
      end

      def mode
        :translate
      end

      private
      # Case-insensitive, and a leading "to " is optional ("to eat" == "eat").
      def comparable(text)
        normalize(text).downcase.sub(/\Ato (?=\S)/, '')
      end
    end
  end
end
