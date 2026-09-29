require 'language_cards/timer'
require 'language_cards/paginator'
require 'language_cards/helpers/view_helper'
require 'language_cards/helpers/game_helper'
require 'language_cards/controllers/main_menu'
require 'language_cards/controllers/game'

module LanguageCards
  class UserInterface
    include Helpers::ViewHelper
    include Controllers
    def initialize menu_items
      @menu_items = menu_items
      @languages = group_by_language(menu_items)
      @mode = [:translate, :typing_practice].cycle
    end

    def start
      unless ENV['SKIP_SPLASH']
        clear
        CLI.say SPLASH_SCREEN
        sleep 2
      end

      catch(:quit) do
        languages.length == 1 ? card_set_menu(languages.keys.first, false) : language_menu
      end
    rescue SystemExit, Interrupt, EOFError
    end

    private
    attr_reader :mode, :menu_items, :languages
    def opts
      @opts ||= {}
    end

    # First screen: pick a language.
    def language_menu
      menu_loop(
        Paginator.new(languages.keys),
        heading: t('Menu.ChooseLanguage'),
        label: ->(language) {
          sets = languages[language].length
          "#{language} (#{sets} #{t(sets == 1 ? 'Menu.Set' : 'Menu.Sets')})"
        }
      ) {|language| card_set_menu(language) }
    end

    # Second screen: pick a card set for the chosen language.
    def card_set_menu(language, back = true)
      menu_loop(
        Paginator.new(languages[language]),
        heading: "#{language}#{JOIN}#{t('Menu.ChooseCardSet')}",
        back: back,
        label: ->(course) { "#{course.title(JOIN, 1..-1)} (#{course.size} #{t('Menu.Cards')})" }
      ) {|course| play(course) }
    end

    # Renders a paginated menu until the user goes back.  Selected items
    # are yielded to the block.
    def menu_loop(pages, heading:, label:, back: false)
      loop do
        clear
        CLI.say MainMenu.new(opts).render courses: pages.current.map {|_, item| label.(item) },
                                          offset: pages.offset,
                                          mode: mode,
                                          heading: heading,
                                          pages: pages,
                                          back: back

        value = CLI.ask("").to_s.strip

        case value
        when /\Am\z/i then mode.next
        when /\An\z/i, '>' then pages.next_page
        when /\Ap\z/i, '<' then pages.previous_page
        when /\Ab\z/i then return if back
        when /\Aq\z/i then throw :quit
        else
          item = pages[value]
          yield item if item
        end
      end
    end

    def play(course)
      title = "#{course.title} (#{humanize mode.peek})"
      collection = course.game(mode.peek) # Mode<CardSet> < Game
      game = Game.new(opts)
      timer = Timer.new
      correct = incorrect = last = nil

      loop do # Game Loop
        clear
        timer.mark
        CLI.say game.render correct: correct,
                            incorrect: incorrect,
                            title: title,
                            timer: timer,
                            last: last
        result = game.process(collection)
        if result[:correct]
          correct = correct.to_i + 1
        else
          incorrect = incorrect.to_i + 1
        end
        last = result[:last]
      end
    rescue Interrupt # CTRL-C returns to the menu
    end

    # @return Hash{String => Array<MenuNode>} languages sorted by name
    def group_by_language(menu_items)
      if menu_items.empty?
        opts[:errors] = ["No Flash Cards found for language: #{CARD_LANGUAGE}"]
      end

      menu_items.group_by {|item| item.label.first }
                .sort_by {|language, _| language.downcase }
                .to_h
    end
  end
end


SPLASH_SCREEN = %q(
  _            _       __    _    ____    _     _      _        ____    _______
 | |          / \     |  \  | |  / __ \  | |   | |    / \      / __ \  |  _____|
 | |         / _ \    |   \ | | / /  \_\ | |   | |   / _ \    / /  \_\ | |
 | |        / /_\ \   | |\ \| || |   ___ | |   | |  / /_\ \  | |   ___ | ^‒‒‒v
 | |       / _____ \  | | \ \ || |  |_  || |   | | / _____ \ | |  |_  || .‒‒‒^
 | |____  / /     \ \ | |  \  | \ \__/  | \ \_/ / / /     \ \ \ \__/  || |_____
 |______|/_/       \_\|_|   \_|  \____/_|  \___/ /_/       \_\ \____/_||_______|
 
 
                   ____        _       _____     _____     _____   
                  / __ \      / \     |  __ \   |  __ \   / ___/
                 / /  \_\    / _ \    | |  \ \  | |  \ \ / /__ 
                | |         / /_\ \   | |__/ /  | |  | | \___ \
                | |    _   / _____ \  |  __ <   | |  | |     \ \
                 \ \__/ / / /     \ \ | |  \ \  | |__/ /  ___/ / 
                  \____/ /_/       \_\|_|   \_\ |_____/  /____/
 
 
 
 
                               by Daniel P. Clark
 
                                     @6ftdan
)
