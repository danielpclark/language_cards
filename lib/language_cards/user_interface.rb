

module LanguageCards
  class UserInterface
    def initialize
      @last = nil
      @mode = [:translate, :typing].cycle
    end

    def main_menu(courses:)
      title = I18n.t 'Menu.Title'
      select = I18n.t 'Menu.Choose'
      mode = case @mode.peek
             when :translate then I18n.t('Menu.ModeTranslate')
             when :typing then I18n.t('Menu.ModeTyping')
             end
      mexit = I18n.t 'Menu.Exit'

<<-MAINMENU
#{'~' * SUBMENUWIDTH}
#{title}#{('v' + VERSION).rjust(SUBMENUWIDTH - title.length)}
#{'~' * SUBMENUWIDTH}
#{select}#{(I18n.t('Menu.GameMode') + mode).rjust(SUBMENUWIDTH - select.length)}

#{ courses.each.with_index.map {|item,index| "#{index + 1}: #{item}\n" }.join.chop }

#{mexit}#{("m: " + I18n.t('Menu.ToggleGameMode')).rjust(SUBMENUWIDTH - mexit.length)}
#{'~' * SUBMENUWIDTH}
MAINMENU
    end

    def score_menu(correct:, incorrect:)
      score = "#{I18n.t 'Game.ScoreMenu.Score'}: #{correct.to_i} #{I18n.t 'Game.ScoreMenu.OutOf'} #{correct.to_i + incorrect.to_i}"

<<-SCOREMENU
#{'~' * SUBMENUWIDTH}
#{score + I18n.t('Menu.Exit').rjust(SUBMENUWIDTH - score.length)}
#{@last}
#{'~' * SUBMENUWIDTH}
SCOREMENU
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
            begin
              loop do
                clear
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
