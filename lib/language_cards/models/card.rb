
module LanguageCards
  class Card
    attr_reader :translation
    def initialize card, translation
      @card = card.to_s
      @translation = Array(translation).map(&:to_s)
    end

    def display
      @card
    end

    def to_s
      @card
    end
  end
end
