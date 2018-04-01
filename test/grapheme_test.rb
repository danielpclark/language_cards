require 'test_helper'

include LanguageCards

class GraphemeTest < Minitest::Test
  attr_reader :grapheme
  def setup
    @grapheme = Grapheme.new('く', 'ku')
  end

  def test_defaults
    assert_equal 'く', "#{grapheme}"
    assert_equal 'ku', grapheme.translation
  end
end
