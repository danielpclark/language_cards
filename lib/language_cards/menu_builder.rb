require 'language_cards/menu_node'

module LanguageCards
  def self.menu_builder(cards_yaml)
    cards_yaml.each_with_object([]) do |(language, values), memo|
      values.each do |category_with_card_set|
        memo << MenuNode.new(language, category_with_card_set)
      end
    end
  end
end
