require 'test_helper'

class LanguageCardsTest < Minitest::Test
  include LanguageCards
  def test_that_it_has_a_version_number
    refute_nil VERSION
  end

  def test_i18n_loads_translation
    refute_empty ::I18n.load_path
  end

  def test_clear_is_a_valid_clear_string
    assert_kind_of String, ESC::CLEAR
    refute ESC::CLEAR.empty?
  end

  def test_mkmf_log_file_avoided
    refute File.exist?(File.join('..', 'mkmf.log'))
    refute File.exist?('mkmf.log')
  end

  def test_cards_load
    cc = LanguageCards.menu_builder YAMLLoader.new.load
    assert_kind_of MenuNode, cc.first
    assert cc.detect {|i| /Japanese/ === "#{i}"}
  end
end
