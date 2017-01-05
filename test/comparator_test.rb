require 'test_helper'
require_relative 'support'

class LanguageCardsTest < Minitest::Test
  include Support
  def test_creates_valid_comp_bitz
    comparator = LanguageCards::Comparator.new(mapping_key, mapping, collection)
    comp_bitz = comparator.given("a", "ア")
    assert_kind_of LanguageCards::CompBitz, comp_bitz
    assert_equal "a", comp_bitz.expected
    assert_equal "ア", comp_bitz.display
    assert_equal "ア", comp_bitz.value
    assert_kind_of LanguageCards::CardCollection, comp_bitz.collection
    assert_equal :k, comp_bitz.mapping
  end

  def test_valid_typing_comp_bitz_object
    comparator = LanguageCards::Comparator.new(mapping_key2, mapping2, collection2)
    comp_bitz = comparator.given("a", "ア")
    assert_kind_of LanguageCards::CompBitz, comp_bitz
    assert_equal "ア", comp_bitz.expected
    assert_equal "ア", comp_bitz.display
    assert_equal "ア", comp_bitz.value
    assert_kind_of LanguageCards::CardCollection, comp_bitz.collection
    assert_equal :v, comp_bitz.mapping
  end
end
