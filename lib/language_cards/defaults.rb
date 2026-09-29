require 'highline'
require 'slop'
require 'i18n'

module LanguageCards
  # Card files and terminal input are UTF-8 even when the locale isn't set.
  Encoding.default_external = Encoding::UTF_8 unless Encoding.default_external == Encoding::UTF_8

  OPTS = Slop.parse(suppress_errors: true) do |args|
    args.banner = 'usage: language_cards [options]'
    args.string '-l', '--language', 'language (default: en)', default: 'en'
    args.bool '-v', '--version', 'print the version'
    args.bool '-h', '--help', 'print this help'
  end

  CARD_LANGUAGE = OPTS[:language]

  module ESC
    CLEAR = (ERASE_SCOLLBACK = "\e[3J") + (CURSOR_HOME = "\e[H") + (ERASE_DISPLAY = "\e[2J")
  end

  CLI = HighLine.new
  JOIN = " - "

  SUBMENUWIDTH = 60

  # Menu entries shown per page before paginating.
  PER_PAGE = 10

  ::I18n.config.available_locales = :en
  ::I18n.load_path = Dir[File.join(File.expand_path(File.join('..','..'), __dir__), 'locales', '*.yml')]
  ::I18n.load_path += Dir[File.join(File.expand_path(ENV['HOME']), '.language_cards', 'locales', '*.yml')] if ENV['HOME']
end
