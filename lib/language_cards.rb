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

module LanguageCards
  CLEAR = begin
            require 'mkmf'
            clear = case RbConfig::CONFIG['target_os']
            when /mingw32|mswin/
              MakeMakefile.find_executable('cls')
            else
              MakeMakefile.find_executable('clear')
              File.delete('mkmf.log')
            end
            clear ? `#{clear}` : "\e[3J\e[H\e[2J"
          end

  CLI = HighLine.new
  JOIN = " : "

  SUBMENUWIDTH = 60

  ::I18n.load_path = Dir[File.join(File.expand_path(File.join('..','..'), __FILE__), 'locales', '*.yml')]
  ::I18n.load_path += Dir[File.join(File.expand_path(ENV['HOME']), '.language_cards', 'locales', '*.yml')]

  def self.start
    LanguageCards.new.start
  end
end
