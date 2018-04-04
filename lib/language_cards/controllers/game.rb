require 'language_cards/controllers/application_controller'

module LanguageCards
  module Controllers
    class Game < ApplicationController
      include Helpers::GameHelper

      def render(correct:, incorrect:, title:, timer:, last:)
        _score = t('Game.ScoreMenu.Score') + ": %0.2d%%" % calc_score(correct, incorrect)
        _timer = [((t('Timer.Timer') + ": " + timer.ha) if timer.time?), nil, timer.h]
        _mexit = t 'Menu.Exit'

        super(binding)
      end

      def process(cards, mode)
        ic = struct_data.new(cards, mode)
        ic.get_input
        {
          correct: ic.valid?,
          last: ic.valid? ? ic.correct_msg : ic.incorrect_msg
        }
      end

      def struct_data
        Struct.new(:game, :mode) do
          def input
            @input 
          end

          def get_input
            @input ||= CLI.ask("#{I18n.t('Game.TypeThis')}: #{display}")
          end

          def card
            @card ||= game.sample.current
          end

          def display
            "#{card}"
          end

          def expected
            case mode
            when :translate
              card.translation
            when :typing_practice
               "#{card}" 
            else
              raise "Invalid mode in Game Controller!"
            end
          end

          def correct_msg
            "#{I18n.t('Game.Correct')} #{input} = #{display}"
          end

          def incorrect_msg
            output = "#{I18n.t('Game.Incorrect')} #{input} != #{display}"
            output << " #{I18n.t('Game.Its')} #{expected.join(', ')}" if mode == :translate
            output
          end

          def valid?
            game.match? input
          end
        end
      end
    end
  end
end
