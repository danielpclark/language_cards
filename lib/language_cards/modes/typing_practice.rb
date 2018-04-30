require 'language_cards/modes/game'
module LanguageCards
  module Modes
    def self.typing_practice card_set
      TypingPractice.new card_set
    end

    class TypingPractice < Game
      def match? input
        "#{current}" == input
      end

      def mode
        :typing_practice
      end
    end
  end
end
