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

  def test_rand
    comp_bitz = collection.rand
    assert_kind_of LanguageCards::CompBitz, comp_bitz
    assert_equal "a", comp_bitz.expected
    assert_equal "ア", comp_bitz.display
    assert_equal "ア", comp_bitz.value
    assert_kind_of LanguageCards::CardCollection, comp_bitz.collection
    assert_equal :k, comp_bitz.mapping
  end

  def test_mapped_as
    assert_equal("Romaji", collection.mapped_as)
    assert_equal("Hiragana", collection2.mapped_as)
  end

  def test_children
    refute collection.children
    refute collection2.children
    c = LanguageCards::LanguageCards.new.instance_variable_get(:@CARDS).children
    assert c
    assert c.count {|k,v| v.kind_of? LanguageCards::CardCollection} > 0
  end

  def test_select_collection
    cc = LanguageCards::LanguageCards.new.instance_variable_get(:@CARDS)
    c = cc.select_collection(cc.classes.first)
    assert_kind_of LanguageCards::CardCollection, c
  end

  def test_raises_errors_on_empty_collection
    cc = LanguageCards::LanguageCards.new.instance_variable_get(:@CARDS)
    cc.instance_variable_set(:@cards, nil)
    assert_raises {cc.rand}
    assert_raises {cc.correct?}
    assert_raises {cc.mapped_as}
    assert_raises {cc.cards}
  end
end
