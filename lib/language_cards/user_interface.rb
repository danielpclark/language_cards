require_relative 'timer'
require_relative 'helpers/view_helper'
require_relative 'helpers/game_helper'
require_relative 'controllers/main_menu'
require_relative 'controllers/game'
require 'erb'

module LanguageCards
  class UserInterface
    include Helpers::ViewHelper
    include Controllers
    def initialize cards
      @cards = cards
      @courses = cards.classes
      @mode = [:translate, :typing].cycle
    end

    def start
      clear

      CLI.say SPLASH_SCREEN
      sleep 2

      begin
        loop do
          clear

          CLI.say MainMenu.render courses: courses, mode: mode

          value = CLI.ask("")

          next mode.next if value =~ /\Am\z/i
          value = value.to_i - 1 rescue next

          last = nil
          if (0..courses.length-1).include? value
            collection = cards.select_collection(courses(value))
            timer = Timer.new
            begin
              loop do
                clear
                timer.mark
                CLI.say Game.render correct: @correct,
                                    incorrect: @incorrect,
                                    title: collection.name,
                                    timer: timer,
                                    last: last
                result = Game.process(collection, mode)
                result[:correct] ? correct : incorrect
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
    attr_reader :mode, :cards
    def correct
      @correct = @correct.to_i + 1
    end

    def incorrect
      @incorrect = @incorrect.to_i + 1
    end

    def courses(value = nil)
      courses = @courses.select {|c| detect_course_mode(c) == mode.peek }
      value ? courses[value] : courses
    end

    def detect_course_mode str
      str.split(JOIN).last.split(" => ").inject(:==) ? :typing : :translate
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
