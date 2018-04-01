
module LanguageCards
  class Grapheme
    attr_reader :translation
    def initialize grapheme, translation
      @grapheme = grapheme
      @translation = Array(translation)
    end

    def display
      @grapheme
    end

    def to_s
      @grapheme
    end
  end
end
