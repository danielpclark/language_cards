

module LanguageCards
  class UserInterface
    def main_menu(courses:)
<<-MAINMENU
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#{I18n.t 'Menu.Title'}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select an option:

#{ courses.each.with_index.map {|item,index| "#{index + 1}: #{item}\n" }.join.chop }
#{ courses.length + 1}: Exit

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MAINMENU
    end


    def start_menu(cards)
      clear

      puts SPLASH_SCREEN
      sleep 2
      clear
      
      puts main_menu(courses: cards.classes)
      #opt = CLI.choose do |menu|
      #  menu.prompt = I18n.t 'Menu.Choose'
      #  @CARDS.classes.each do |item|
      #    menu.choice(item) 
      #  end
      #  menu.choice(I18n.t 'Menu.Exit' )
      #end
      #return if opt == I18n.t('Menu.Exit')
      #collection = @CARDS.select_collection(opt)

      #loop do
      #  comp_bitz = collection.rand
      #  input = CLI.ask("#{I18n.t('Game.TypeThis')} #{collection.mapped_as.first}: #{comp_bitz.display}")
      #  break if input == 'q'
      #  if collection.correct? input, comp_bitz
      #    CLI.say I18n.t('Game.Correct')
      #  else
      #    CLI.say I18n.t('Game.Incorrect')
      #  end
      #end
    end

    private
    ##
    # TODO: Check local operating system for clear or cls command and dynamically define this method via
    #       that commands output.
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
