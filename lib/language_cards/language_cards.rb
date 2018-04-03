require 'language_cards/menu_node'
require 'language_cards/yaml_loader'
require 'language_cards/user_interface'

module LanguageCards
  class LanguageCards
    def initialize
      self.cards = builder(YAMLLoader.new.load)
    end

    def start
      UserInterface.new(cards).start
    end

    private
    attr_accessor :cards
    def builder(cards_yaml)
      cards_yaml.each_with_object([]) do |(language, values), memo|
        values.each do |category_with_card_set|
          memo << MenuNode.new(language, category_with_card_set)
        end
      end
    end
  end
end
