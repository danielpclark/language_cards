require 'language_cards/version'
require 'language_cards/language_cards'
require 'yaml'
require 'i18n'
require 'slop'
require 'highline'

##
# TODO:
#  * Implement score-keeper
#  * Race against the clock
#  * Weighted random for better learning

module LanguageCards
  OPTS = Slop.parse do |args|
    args.string '-l', '--language', 'language (default: en)', default: 'en'
  end

  CARD_LANGUAGE = OPTS[:language]

  module ESC
    CLEAR = (ERASE_SCOLLBACK = "\e[3J") + (CURSOR_HOME = "\e[H") + (ERASE_DISPLAY = "\e[2J")
  end

  CLI = HighLine.new
  JOIN = " : "

  SUBMENUWIDTH = 60

  ::I18n.load_path = Dir[File.join(File.expand_path(File.join('..','..'), __FILE__), 'locales', '*.yml')]
  ::I18n.load_path += Dir[File.join(File.expand_path(ENV['HOME']), '.language_cards', 'locales', '*.yml')] if ENV['HOME']

  def self.start
    LanguageCards.new.start
  end
end
