module LanguageCards
  class YAMLLoader
    def initialize
      @language = CARD_LANGUAGE
    end

    def load
      cards = {}

      cards_yaml.each do |c|
        next unless yaml_data = YAML.load(File.open(c).read)
        for language in yaml_data.keys do
          # Merges sub-items for languages
          if cards.has_key? language
            cards[language] = Hash( cards[language] ).merge( Hash(yaml_data[language]) )
          else
            # Merges in new top scope languages
            cards.merge!({ language => yaml_data[language] })
          end
        end
      end

      cards
    end

    private
    attr_reader :language

    def application_path
      File.expand_path(File.join('..','..'), __dir__)
    end

    def cards_yaml
      application_path_cards_yaml + home_path_cards_yaml
    end

    def application_path_cards_yaml
      Dir[File.join(application_path, 'cards', language, '*.yml')]
    end

    def home_path_cards_yaml
      if ENV['HOME']
        Dir[File.join(ENV['HOME'], '.language_cards', 'cards', language, '*.yml')]
      else
        []
      end
    end
  end
end
