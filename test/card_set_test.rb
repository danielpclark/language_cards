require 'test_helper'

include LanguageCards

class CardSetTest < Minitest::Test
  attr_reader :card_set
  def setup
    @card_set = CardSet.new({'く' => 'ku'})
  end

  def test_creates_collection
    assert card_set.respond_to? :mode
    assert card_set.respond_to? :cards
    assert card_set.cards.first.respond_to? :translation
  end

  def test_modes
    card = card_set.mode(:translate)
    card.sample
    assert card.match? 'ku' 

    card = card_set.mode(:typing_practice)
    card.sample
    assert card.match? 'く'
  end
end
