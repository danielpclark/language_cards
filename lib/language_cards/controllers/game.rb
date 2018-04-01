module LanguageCards
  module Controllers
    module Game
      class << self
        include Helpers::ViewHelper
        include Helpers::GameHelper

        def render(correct:, incorrect:, title:, timer:, last:)
          _score = t('Game.ScoreMenu.Score') + ": %0.2d%%" % calc_score(correct, incorrect)
          _timer = [((t('Timer.Timer') + ": " + timer.ha) if timer.time?), nil, timer.h]
          _mexit = t 'Menu.Exit'

          view = File.expand_path('../view/game.erb', __dir__).
            ᐅ( IO.method :read ).
            ᐅ ERB.method :new
          view.result(binding)
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
          Struct.new(:collection, :mode) do
            def input
              @input 
            end

            def get_input
              @input ||= CLI.ask("#{I18n.t('Game.TypeThis')}: #{display}")
            end

            def card
              @card ||= collection.sample
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
              output << " #{I18n.t('Game.Its')} #{expected}" if mode == :translate
              output
            end

            def valid?
              !!(expected == input)
            end
          end
        end
      end
    end
  end
end
