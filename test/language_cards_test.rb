require 'test_helper'

class LanguageCardsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::LanguageCards::VERSION
  end

  def test_clear_is_a_valid_clear_string
    assert_kind_of String, LanguageCards::CLEAR
    refute LanguageCards::CLEAR.empty?
  end

  def test_mkmf_log_file_removed
    refute File.exist?(File.join('..', 'mkmf.log'))
    refute File.exist?('mkmf.log')
  end
end
