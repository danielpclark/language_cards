require 'language_cards/modes/game'
module LanguageCards
  module Modes
    def self.translate card_set
      Translate.new card_set
    end

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
