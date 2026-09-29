require 'language_cards/controllers/application_controller'

module LanguageCards
  module Controllers
    class MainMenu < ApplicationController
      # @param courses [Array<String>] labels for the entries on the current page
      # @param offset [Integer] number of entries on the pages before this one
      # @param pages [Paginator, nil] used to show page navigation when needed
      def render(courses:, mode:, offset: 0, heading: nil, pages: nil, back: false)
        _title = t 'Menu.Title'
        _select = heading || t('Menu.Choose')
        _mode = t('Menu.GameMode') + case mode.peek
                when :translate then t 'Menu.ModeTranslate'
                when :typing_practice then t 'Menu.ModeTyping'
                end
        _toggle = "m: " + t('Menu.ToggleGameMode')
        width = (offset + courses.length).to_s.length
        _courses = courses.each.with_index(offset + 1).map {|item, number| "#{number.to_s.rjust(width)}: #{item}" }
        _page = page_line(pages)
        _back = ("b: " + t('Menu.Back') if back)
        _quit = "q: " + t('Menu.Quit')
        _mexit = t 'Menu.Exit'

        super(binding)
      end

      private
      def page_line(pages)
        return unless pages && pages.paginated?

        nav = []
        nav << "p: " + t('Menu.PreviousPage') if pages.previous_page?
        nav << "n: " + t('Menu.NextPage') if pages.next_page?
        [t('Menu.Page', page: pages.page + 1, pages: pages.pages), nav.join('  ')]
      end
    end
  end
end
