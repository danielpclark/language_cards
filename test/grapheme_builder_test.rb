require 'test_helper'

include LanguageCards

class GraphemeBuilderTest < Minitest::Test
  attr_reader :builder
  def setup
    @builder = GraphemeBuilder.(
      {'ku' => 'く'}
    )
  end

  def test_defaults
    assert_kind_of Array, builder
    assert_kind_of Grapheme, builder.first
    assert_equal 'ku', builder.first.translation
  end
end
