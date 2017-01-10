require_relative 'card_collection'
require_relative 'user_interface'

module LanguageCards
  class LanguageCards
    def initialize
      @CARDS = {}

      Dir[File.join(File.expand_path(File.join('..','..','..'), __FILE__), 'cards', '*.yml')].each do |c|
        yaml_data = YAML.load(File.open(c).read)
        for language in yaml_data.keys do
          if @CARDS.has_key? language
            @CARDS[language] = Hash(@CARDS[language]).merge(Hash(yaml_data[language]))
          else
            @CARDS.merge!({language => yaml_data[language]})
          end
        end

      end
      @CARDS = CardCollection.new @CARDS
    end

    def start
      UserInterface.new.start(@CARDS)
    end
  end
end
