require 'language_cards/controllers/application_controller'

module LanguageCards
  module Controllers
    class MainMenu < ApplicationController
      def render(courses:, mode:)
        _title = t 'Menu.Title'
        _select = t 'Menu.Choose'
        _mode = t('Menu.GameMode') + case mode.peek
                when :translate then t 'Menu.ModeTranslate'
                when :typing_practice then t 'Menu.ModeTyping'
                end
        _toggle = "m: " + t('Menu.ToggleGameMode')
        _courses = courses.each.with_index.map {|item,index| "#{index + 1}: #{item}" }
        _mexit = t 'Menu.Exit'

        super(binding)
      end
    end
  end
end
