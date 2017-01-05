require 'test_helper'

class CardCollectionTest < Minitest::Test
  def test_card_collection_input_results
    c1 = LanguageCards::Comparator.new(mapping_key, mapping, collection)
    comp_bitz = c1.given("a", "ア")
    assert collection.correct? "a", comp_bitz
    refute collection.correct? "b", comp_bitz

    c2 = LanguageCards::Comparator.new(mapping_key2, mapping2, collection2)
    comp_bitz2 = c2.given("a", "ア")
    assert collection2.correct? "ア", comp_bitz2
    refute collection2.correct? "b", comp_bitz2
  end
end
