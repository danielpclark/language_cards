require 'language_cards/version'
require 'language_cards/defaults'
require 'language_cards/yaml_loader'
require 'language_cards/user_interface'
require 'language_cards/menu_builder'
require 'yaml'

##
# TODO:
#  * Implement score-keeper
#  * Race against the clock
#  * Weighted random for better learning

module LanguageCards
  def self.start
    UserInterface.new(menu_builder YAMLLoader.new.load).start
  end
end
