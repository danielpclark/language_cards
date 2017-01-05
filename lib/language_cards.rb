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
  CLEAR = begin
            require 'mkmf'
            clear = case RbConfig::CONFIG['target_os']
            when /mingw32|mswin/
              MakeMakefile.find_executable('cls')
            else
              MakeMakefile.find_executable('clear')
            end
            clear ? `#{clear}` : "\e[3J\e[H\e[2J"
          ensure
            File.delete('mkmf.log')
          end

  CLI = HighLine.new
  JOIN = " : "

  SUBMENUWIDTH = 60

  ::I18n.load_path = Dir[File.join 'locales', '*.yml']

  def self.start
    LanguageCards.new.start
  end
end
