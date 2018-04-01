require 'language_cards/timer'
require 'language_cards/helpers/view_helper'
require 'language_cards/helpers/game_helper'
require 'language_cards/controllers/main_menu'
require 'language_cards/controllers/game'
require 'erb'

module LanguageCards
  class UserInterface
    include Helpers::ViewHelper
    include Controllers
    def initialize cards
      @cards = cards
      @courses = cards.flat_map {|i| i.label.join(' - ') }
      @mode = [:translate, :typing_practice].cycle
    end

    def start
      unless ENV['SKIP_SPLASH']
        clear
        CLI.say SPLASH_SCREEN
        sleep 2
      end

      begin
        loop do
          clear

          CLI.say MainMenu.render courses: courses, mode: mode

          value = CLI.ask("")

          next mode.next if value =~ /\Am\z/i
          value = value.to_i - 1 rescue next

          last = nil
          if (0..courses.length-1).include? value

            collection = cards[value] # MenuNode
            title = "#{collection.title} (#{humanize mode.peek})"
            collection = collection.mode(mode.peek) # Mode<CardSet> < Game

            timer = Timer.new
            begin # Game Loop
              loop do
                clear
                timer.mark
                CLI.say Game.render correct: correct,
                                    incorrect: incorrect,
                                    title: title,
                                    timer: timer,
                                    last: last
                result = Game.process(collection, collection.mode)
                result[:correct] ? correct! : incorrect!
                last = result[:last]
              end
            rescue SystemExit, Interrupt
            end
          end
        end

      rescue SystemExit, Interrupt
      end
    end

    private
    attr_reader :mode, :cards, :correct, :incorrect, :courses
    def correct!
      @correct = @correct.to_i + 1
    end

    def incorrect!
      @incorrect = @incorrect.to_i + 1
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
