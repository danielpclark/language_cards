require 'highline'
require 'slop'
require 'i18n'

module LanguageCards
  OPTS = Slop.parse do |args|
    args.string '-l', '--language', 'language (default: en)', default: 'en'
  end

  CARD_LANGUAGE = OPTS[:language]

  module ESC
    CLEAR = (ERASE_SCOLLBACK = "\e[3J") + (CURSOR_HOME = "\e[H") + (ERASE_DISPLAY = "\e[2J")
  end

  CLI = HighLine.new
  JOIN = " - "

  SUBMENUWIDTH = 60

  ::I18n.config.available_locales = :en
  ::I18n.load_path = Dir[File.join(File.expand_path(File.join('..','..'), __dir__), 'locales', '*.yml')]
  ::I18n.load_path += Dir[File.join(File.expand_path(ENV['HOME']), '.language_cards', 'locales', '*.yml')] if ENV['HOME']
end
