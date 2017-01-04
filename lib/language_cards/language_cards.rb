require_relative 'card_collection'
require_relative 'user_interface'

module LanguageCards
  class LanguageCards
    def initialize
      @CARDS = {}
      Dir[File.join 'cards', '*.yml'].each do |c|
        @CARDS.merge!(YAML.load(File.open(c).read))
      end
      @CARDS = CardCollection.new @CARDS
    end

    def start_menu
      UserInterface.new.start_menu(@CARDS)
    end
    
    #def start_menu
    #  clear
    #  puts I18n.t 'Menu.Title'
    #  opt = CLI.choose do |menu|
    #    menu.prompt = I18n.t 'Menu.Choose'
    #    @CARDS.classes.each do |item|
    #      menu.choice(item) 
    #    end
    #    menu.choice(I18n.t 'Menu.Exit' )
    #  end
    #  return if opt == I18n.t('Menu.Exit')
    #  collection = @CARDS.select_collection(opt)

    #  loop do
    #    comp_bitz = collection.rand
    #    input = CLI.ask("#{I18n.t('Game.TypeThis')} #{collection.mapped_as.first}: #{comp_bitz.display}")
    #    break if input == 'q'
    #    if collection.correct? input, comp_bitz
    #      CLI.say I18n.t('Game.Correct')
    #    else
    #      CLI.say I18n.t('Game.Incorrect')
    #    end
    #  end
    #end

    #private
    ###
    ## TODO: Check local operating system for clear or cls command and dynamically define this method via
    ##       that commands output.
    #def clear
    #  printf CLEAR
    #end
  end
end
