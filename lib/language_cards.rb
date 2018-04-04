require 'language_cards/version'
require 'language_cards/defaults'
require 'language_cards/yaml_loader'
require 'language_cards/user_interface'
require 'language_cards/menu_builder'

##
# TODO:
#  * Implement score-keeper
#  * Race against the clock
#  * Weighted random for better learning

module LanguageCards
  def self.start
    yaml = YAMLLoader.new.load
    menu = menu_builder(yaml)
    UserInterface.new(menu).start
  end
end
