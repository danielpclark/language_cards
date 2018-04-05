
module LanguageCards
  class Card
    attr_reader :translation
    def initialize card, translation
      @card = card
      @translation = Array(translation)
    end

    def display
      @card
    end

    def to_s
      @card
    end
  end
end
