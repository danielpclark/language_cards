module LanguageCards
  # Splits a list of menu entries into pages so long menus stay readable.
  # Entries keep their absolute numbering across pages, so any listed
  # number can be picked no matter which page is currently shown.
  class Paginator
    attr_reader :items, :per_page, :page

    def initialize(items, per_page = PER_PAGE)
      @items = Array(items)
      @per_page = [per_page.to_i, 1].max
      @page = 0
    end

    # @return Array<Array(Integer, Object)> number/item pairs for the current page
    def current
      items.each_with_index
           .map {|item, index| [index + 1, item] }
           .slice(page * per_page, per_page) || []
    end

    def pages
      [(items.length.to_f / per_page).ceil, 1].max
    end

    def paginated?
      pages > 1
    end

    def next_page?
      page < pages - 1
    end

    def previous_page?
      page > 0
    end

    def next_page
      @page += 1 if next_page?
      self
    end

    def previous_page
      @page -= 1 if previous_page?
      self
    end

    # @param number [Integer] the 1-based number shown in the menu
    # @return the item for that number or nil
    def [](number)
      number = Integer(number) rescue (return nil)
      return nil unless (1..items.length).include?(number)
      items[number - 1]
    end

    def offset
      page * per_page
    end
  end
end
