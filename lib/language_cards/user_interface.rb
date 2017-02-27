require_relative 'timer'
require 'erb'

module LanguageCards
  class UserInterface
    def initialize
      @last = nil
      @mode = [:translate, :typing].cycle
      @title = ""
    end

    def divider
      '~' * SUBMENUWIDTH
    end

    def t str
      I18n.t str
    end

    def main_menu(courses:)
      _title = t 'Menu.Title'
      _select = t 'Menu.Choose'
      _mode = case @mode.peek
              when :translate then t 'Menu.ModeTranslate'
              when :typing then t 'Menu.ModeTyping'
              end
      _courses = courses.each.with_index.map {|item,index| "#{index + 1}: #{item}" }
      _mexit = t 'Menu.Exit'

      view = ERB.new(IO.read(File.expand_path('view/main_menu.erb', __dir__)))
      view.result(binding)
    end

    def calc_score c, i
      (0.001+c.to_i)*100.0/(c.to_i+i.to_i+0.001)*1.0
    end

    def score_menu(correct:, incorrect:)
      _score = t('Game.ScoreMenu.Score') + ": %0.2d%" % calc_score(correct, incorrect)
      _timer = @timer.time? ? (t('Timer.Timer') + ": " + @timer.ha) : ""
      _timer = _timer + @timer.h.rjust(SUBMENUWIDTH - _timer.length)
      _title = @title.to_s
      _last = @last
      _mexit = t 'Menu.Exit'

      view = ERB.new(IO.read(File.expand_path('view/game.erb', __dir__)))
      view.result(binding)
    end

    def draw left=nil, center=nil, right=nil
      width = SUBMENUWIDTH
      str = left.to_s
      str = str + center.to_s.rjust(width/2 - str.length + center.to_s.length/2)
      str + right.to_s.rjust(width - str.length)
    end

    def start(cards)
      @courses = cards.classes
      clear

      CLI.say SPLASH_SCREEN
      sleep 2

      begin
        loop do
          clear

          CLI.say main_menu(courses: courses)

          value = CLI.ask("")

          next @mode.next if value =~ /\Am\z/i
          value = value.to_i - 1 rescue next

          @last = nil
          if (0..courses.length-1).include? value
            collection = cards.select_collection(courses(value))
            @title = collection.name
            @timer = Timer.new
            begin
              loop do
                clear
                @timer.mark
                CLI.say score_menu(correct: @correct, incorrect: @incorrect)
                game_logic(collection)
              end
            rescue SystemExit, Interrupt
            end
          end
        end

      rescue SystemExit, Interrupt
      end
    end

    private
    def clear
      printf ::LanguageCards::ESC::CLEAR
    end

    IC=Struct.new(:collection, :mode) do
      def input
        @input 
      end

      def get_input
        @input ||= CLI.ask("#{I18n.t('Game.TypeThis')} #{collection.mapped_as}: #{display}")
      end

      def comp_bitz
        @comp_bitz ||= collection.rand
      end

      def display
        comp_bitz.display
      end

      def expected
        comp_bitz.expected
      end

      def correct_msg
        "#{I18n.t('Game.Correct')} #{input} = #{display}"
      end

      def incorrect_msg
        output = "#{I18n.t('Game.Incorrect')} #{input} != #{display}"
        output << " #{I18n.t('Game.Its')} #{expected}" if mode == :translate
        output
      end

      def valid?
        collection.correct?(input, comp_bitz)
      end
    end

    def game_logic(c)
      ic = IC.new(c, @mode.peek)
      ic.get_input
      ic.valid? ? last_was_correct(ic) : last_was_incorrect(ic)
    end

    def last_was_correct(ic)
      @correct = @correct.to_i + 1
      @last = ic.correct_msg
    end

    def last_was_incorrect(ic)
      @incorrect = @incorrect.to_i + 1
      @last = ic.incorrect_msg
    end

    def courses(value = nil)
      courses = @courses.select {|c| detect_course_mode(c) == @mode.peek }
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
