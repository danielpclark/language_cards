require 'test_helper'

include LanguageCards

class CardTest < Minitest::Test
  attr_reader :card
  def setup
    @card = Card.new('く', 'ku')
  end

  def test_defaults
    assert_equal 'く', "#{card}"
    assert_equal 'ku', *card.translation
  end
end
