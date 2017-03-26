require_relative 'card_collection'
require_relative 'user_interface'

module LanguageCards
  class LanguageCards
    def initialize
      @CARDS = {}

      File.join('..','..').
        ᐅ(File.method(:expand_path), __dir__  ).
        ᐅ(File.method(:join), 'cards', '*.yml').
        ᐅ(Dir.method :[]                      ).
        +(
          if ENV['HOME']
            File.expand_path(ENV['HOME']).
              ᐅ(File.method(:join), '.language_cards', 'cards', '*.yml').
              ᐅ Dir.method :[]
          else
            []
          end
        ).
          each do |c|
          next unless yaml_data = c.ᐅ(File.method :open).ᐅ(~:read).ᐅ(YAML.method :load)
          for language in yaml_data.keys do
            if @CARDS.has_key? language
              @CARDS[language] = \
                yaml_data[language].
                ᐅ(method :Hash).
                ᐅ @CARDS[language].
                  ᐅ(method :Hash).
                  method(:merge)
            else
              { language => yaml_data[language] }.
                ᐅ @CARDS.method :merge!
            end
          end

        end
      # Recursive Builder
      @CARDS = CardCollection.new @CARDS
    end

    def start
      @CARDS.ᐅ(UserInterface.method :new).ᐅ ~:start
    end
  end
end
