require 'test_helper'
require 'language_cards/timer'

class TimerTest < Minitest::Test
  def test_timer_returns_float_greater_than_zero
    t = LanguageCards::Timer.new
    t.mark
    t.mark
    assert_includes 0..2, t.times.first
    assert_includes 0..2, t.last
    assert_includes 0..2, t.total
    assert_kind_of Float, t.total
  end
end
