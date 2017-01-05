require 'test_helper'

class ComparatorTest < Minitest::Test
  def test_creates_valid_comp_bitz
    c1 = LanguageCards::Comparator.new(mapping_key, mapping, collection)
    comp_bitz = c1.given("a", "ア")
    assert_kind_of LanguageCards::CompBitz, comp_bitz
    assert_equal "a", comp_bitz.expected
    assert_equal "ア", comp_bitz.display
    assert_equal "ア", comp_bitz.value
    assert_kind_of LanguageCards::CardCollection, comp_bitz.collection
    assert_equal :k, comp_bitz.mapping
  end

  def test_valid_typing_comp_bitz_object
    c2 = LanguageCards::Comparator.new(mapping_key2, mapping2, collection2)
    comp_bitz = c2.given("a", "ア")
    assert_kind_of LanguageCards::CompBitz, comp_bitz
    assert_equal "ア", comp_bitz.expected
    assert_equal "ア", comp_bitz.display
    assert_equal "ア", comp_bitz.value
    assert_kind_of LanguageCards::CardCollection, comp_bitz.collection
    assert_equal :v, comp_bitz.mapping
  end

  def test_comparator_input_results
    c1 = LanguageCards::Comparator.new(mapping_key, mapping, collection)
    comp_bitz = c1.given("a", "ア")
    assert c1.match? "a", comp_bitz
    refute c1.match? "b", comp_bitz

    c2 = LanguageCards::Comparator.new(mapping_key2, mapping2, collection2)
    comp_bitz2 = c2.given("a", "ア")
    assert c2.match? "ア", comp_bitz2
    refute c2.match? "b", comp_bitz2
  end
end
