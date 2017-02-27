module LanguageCards
  module Controllers
    module MainMenu
      class << self
        include Helpers::ViewHelper

        def render(courses:, mode:)
          _title = t 'Menu.Title'
          _select = t 'Menu.Choose'
          _mode = t('Menu.GameMode') + case mode.peek
                  when :translate then t 'Menu.ModeTranslate'
                  when :typing then t 'Menu.ModeTyping'
                  end
          _toggle = "m: " + t('Menu.ToggleGameMode')
          _courses = courses.each.with_index.map {|item,index| "#{index + 1}: #{item}" }
          _mexit = t 'Menu.Exit'

          view = ERB.new(IO.read(File.expand_path('../view/main_menu.erb', __dir__)))
          view.result(binding)
        end
      end
    end
  end
end
