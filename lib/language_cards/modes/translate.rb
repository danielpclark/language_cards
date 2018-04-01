require 'language_cards/modes/game'
module LanguageCards
  module Modes
    class Translate < Game
      def match? input
        current.translation.any? {|value| value == input }
      end

      def mode
        :translate
      end
    end
  end
end
