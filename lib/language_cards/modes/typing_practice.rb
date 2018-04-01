require 'language_cards/modes/game'
module LanguageCards
  module Modes
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
