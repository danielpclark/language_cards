require 'language_cards/modes/game'
module LanguageCards
  module Modes
    class Translate < Game
      def match? input
        current.translation == input
      end

      def mode
        :translate
      end
    end
  end
end
