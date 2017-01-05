require_relative 'card_collection'
require_relative 'user_interface'

module LanguageCards
  class LanguageCards
    def initialize
      @CARDS = {}

      Dir[File.join(File.expand_path(File.join('..','..','..'), __FILE__), 'cards', '*.yml')].each do |c|
        @CARDS.merge!(YAML.load(File.open(c).read))
      end
      @CARDS = CardCollection.new @CARDS
    end

    def start
      UserInterface.new.start(@CARDS)
    end
  end
end
