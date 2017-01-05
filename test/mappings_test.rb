require 'test_helper'

class MappingsTest < Minitest::Test
  def test_failed_mapping
    assert_raises {LanguageCards::Mappings.new([{'a' => 'b', 'c' => 'd', 'incoming' => [:k, :v]}])}
  end
end
