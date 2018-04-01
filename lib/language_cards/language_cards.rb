require 'language_cards/menu_node'
require_relative 'user_interface'

module LanguageCards
  class LanguageCards
    def initialize
      @CARDS = {}

      # TODO: Extract out YAML file loading behavior to methods via SRP.
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
            # Merges sub-items for languages
            if @CARDS.has_key? language
              @CARDS[language] = \
                yaml_data[language].
                ᐅ(method :Hash).
                ᐅ @CARDS[language].
                  ᐅ(method :Hash).
                  method(:merge)
            else
              # Merges top scope languages
              { language => yaml_data[language] }.
                ᐅ @CARDS.method :merge!
            end
          end

        end

      # Builder
      @CARDS = @CARDS.each_with_object([]) do |(language, values), memo|
        values.each do |category_with_card_set|
          memo << MenuNode.new(language, category_with_card_set)
        end
      end
    end

    def start
      @CARDS.ᐅ(UserInterface.method :new).ᐅ ~:start
    end
  end
end
