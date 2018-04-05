require 'test_helper'

include LanguageCards

class CardSetBuilderTest < Minitest::Test
  include CardSetBuilder
  attr_reader :builder
  def setup
    @builder = card_set_builder(
      {'く' => 'ku'}
    )
  end

  def test_defaults
    assert_kind_of Array, builder
    assert_kind_of Card, builder.first
    assert_equal 'ku', builder.first.translation.first
  end
end
