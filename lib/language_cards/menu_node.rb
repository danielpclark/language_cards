require 'language_cards/models/card_set'
module LanguageCards
  class MenuNode
    def initialize name, child
      @name = name

      if child.is_a?(Hash) and child.has_key?("mapping")
        @mapping = child.delete("mapping") # Extra unused data for the moment
        @child = CardSet.new(child)
      else
        @child = MenuNode.new(*child)
      end
    end

    def title(fmt = JOIN, rng = 0..-1)
      label[rng].delete_if(&:empty?).join(fmt)
    end

    # @return <Mode<CardSet> < Game>
    def mode(game_mode)
      child.mode(game_mode)
    end

    # This is the preferred method for the view as this object shouldn't
    # care about how it should be displayed in the view.
    # @return Array<String>
    def label
      [@name].push(*child.label)
    end

    def to_s
      label.delete_if(&:empty?).join(JOIN)
    end

    private
    attr_reader :name, :child
  end
end
