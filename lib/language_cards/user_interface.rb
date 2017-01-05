

module LanguageCards
  class UserInterface
    def main_menu(courses:)
      title = I18n.t 'Menu.Title'
<<-MAINMENU
#{'~' * SUBMENUWIDTH}
#{title}#{('v' + VERSION).rjust(SUBMENUWIDTH - title.length)}
#{'~' * SUBMENUWIDTH}

Select an option:

#{ courses.each.with_index.map {|item,index| "#{index + 1}: #{item}\n" }.join.chop }
#{I18n.t 'Menu.Exit'}

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
      clear

      CLI.say SPLASH_SCREEN
      sleep 2

      begin
        loop do
          clear
          
          CLI.say main_menu(courses: cards.classes)
          value = CLI.ask("").to_i - 1
          courses = cards.classes
          if (0..courses.length-1).include? value
            collection = cards.select_collection(courses[value])
            begin
              loop do
                clear
                CLI.say score_menu(correct: @correct, incorrect: @incorrect)
                comp_bitz = collection.rand
                input = CLI.ask("#{I18n.t('Game.TypeThis')} #{collection.mapped_as.first}: #{comp_bitz.display}")
                if collection.correct? input, comp_bitz
                  @correct = @correct.to_i + 1
                  @last = [
                    I18n.t('Game.Correct'),
                    "#{input} = #{comp_bitz.display}"
                  ].join(" ")
                else
                  @incorrect = @incorrect.to_i + 1
                  @last = [
                    I18n.t('Game.Incorrect'),
                    "#{input} != #{comp_bitz.display}",
                    I18n.t('Game.Its'),
                    "#{comp_bitz.expected}"
                  ].join(" ")
                end
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
      printf CLEAR
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
