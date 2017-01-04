require 'language_cards/version'
require 'language_cards/language_cards'
require 'yaml'
require 'i18n'
require 'highline'

##
# TODO:
#  * Implement score-keeper
#  * Race against the clock
#  * Weighted random for better learning
#  * Value to Value is simply keyboard practice and should be clocked
#  * Finish building Hiragana cards (figure out duplicates for ja, ju, jo)

module LanguageCards
  CLEAR = "\e[3J\e[H\e[2J"
  CLI = HighLine.new
  JOIN = " : "

  ::I18n.load_path = Dir[File.join 'locales', '*.yml']

  def self.start
    LanguageCards.new.start_menu
  end
end
