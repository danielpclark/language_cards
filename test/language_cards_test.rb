require 'test_helper'

class LanguageCardsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::LanguageCards::VERSION
  end

  def test_i18n_loads_translation
    refute_empty ::I18n.load_path
  end

  def test_clear_is_a_valid_clear_string
    assert_kind_of String, LanguageCards::CLEAR
    refute LanguageCards::CLEAR.empty?
  end

  def test_mkmf_log_file_removed
    refute File.exist?(File.join('..', 'mkmf.log'))
    refute File.exist?('mkmf.log')
  end

  def test_cards_load
    cc = LanguageCards::LanguageCards.new.instance_variable_get(:@CARDS)
    assert_kind_of LanguageCards::CardCollection, cc
    assert cc.classes.detect {|i| /Japanese/ === i}
  end
end
