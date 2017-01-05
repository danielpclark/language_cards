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
  ##
  # TODO: Check local operating system for clear or cls command and dynamically define this method via
  #       that commands output.
  CLEAR = "\e[3J\e[H\e[2J"

  CLI = HighLine.new
  JOIN = " : "

  SUBMENUWIDTH = 60

  ::I18n.load_path = Dir[File.join 'locales', '*.yml']

  def self.start
    LanguageCards.new.start
  end
end
