module Support
  # Menu numbering of a language as shown on the first menu screen.
  def self.language_number(language)
    languages = LanguageCards.menu_builder(LanguageCards::YAMLLoader.new.load)
                             .map {|item| item.label.first }
                             .uniq
                             .sort_by(&:downcase)
    languages.index(language) + 1
  end
end
