require 'test_helper'

include LanguageCards

class CardSetTest < Minitest::Test
  attr_reader :card_set
  def setup
    @card_set = CardSet.new({'く' => 'ku'})
  end

  def test_creates_collection
    assert card_set.respond_to? :game
    assert card_set.respond_to? :cards
    assert card_set.cards.first.respond_to? :translation
  end

  def test_modes
    card = card_set.game(:translate)
    card.sample
    assert card.match? 'ku' 

    card = card_set.game(:typing_practice)
    card.sample
    assert card.match? 'く'
  end
end

class AnswerMatchingTest < Minitest::Test
  def game(mode, cards)
    LanguageCards::CardSet.new(cards).game(mode).sample
  end

  def test_translate_is_forgiving
    g = game(:translate, {'食べる' => ['たべる', 'eat']})
    assert g.match?('eat')
    assert g.match?('  EAT ')
    assert g.match?('to eat')
    assert g.match?('たべる')
    refute g.match?('drink')
    refute g.match?('')
  end

  def test_translate_handles_unicode_composition
    g = game(:translate, {'爱' => ['ài', 'ai4']})
    assert g.match?("ài")
    assert g.match?('ai4')
  end

  def test_numbers_are_matched_as_text
    g = game(:translate, {'三' => ['three', 3]})
    assert g.match?('3')
  end

  def test_typing_practice_is_exact_apart_from_spacing
    g = game(:typing_practice, {'ア' => 'a'})
    assert g.match?(' ア ')
    refute g.match?('a')
  end

  def test_sample_avoids_immediate_repeats
    g = game(:translate, {'あ' => 'a', 'い' => 'i'})
    previous = g.current
    10.times do
      g.sample
      refute_equal previous, g.current
      previous = g.current
    end
  end
end
