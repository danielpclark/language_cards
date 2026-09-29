require 'test_helper'

class PaginatorTest < Minitest::Test
  def pages
    @pages ||= LanguageCards::Paginator.new((1..23).map {|i| "item #{i}" }, 10)
  end

  def test_first_page
    assert_equal 3, pages.pages
    assert pages.paginated?
    refute pages.previous_page?
    assert pages.next_page?
    assert_equal [1, 'item 1'], pages.current.first
    assert_equal [10, 'item 10'], pages.current.last
    assert_equal 0, pages.offset
  end

  def test_navigation_is_bounded
    3.times { pages.next_page }
    assert_equal 2, pages.page
    assert_equal [[21, 'item 21'], [22, 'item 22'], [23, 'item 23']], pages.current
    refute pages.next_page?

    5.times { pages.previous_page }
    assert_equal 0, pages.page
  end

  def test_selection_uses_absolute_numbers
    assert_equal 'item 1', pages['1']
    assert_equal 'item 23', pages[23]
    assert_nil pages['0']
    assert_nil pages['24']
    assert_nil pages['abc']
    assert_nil pages['']
  end

  def test_single_page
    single = LanguageCards::Paginator.new(%w[a b], 10)
    assert_equal 1, single.pages
    refute single.paginated?
    assert_equal [[1, 'a'], [2, 'b']], single.current
  end

  def test_empty
    empty = LanguageCards::Paginator.new([], 10)
    assert_equal 1, empty.pages
    assert_empty empty.current
  end
end
