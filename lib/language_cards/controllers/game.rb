module LanguageCards
  module Controllers
    module Game
      class << self
        include Helpers::ViewHelper
        include Helpers::GameHelper

        def render(correct:, incorrect:, title:, timer:, last:)
          _score = t('Game.ScoreMenu.Score') + ": %0.2d%" % calc_score(correct, incorrect)
          _timer = [((t('Timer.Timer') + ": " + timer.ha) if timer.time?), nil, timer.h]
          _mexit = t 'Menu.Exit'

          view = ERB.new(IO.read(File.expand_path('../view/game.erb', __dir__)))
          view.result(binding)
        end

        def process(card_collection, mode)
          ic = struct_data.new(card_collection, mode.peek)
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
              @input ||= CLI.ask("#{I18n.t('Game.TypeThis')} #{collection.mapped_as}: #{display}")
            end

            def comp_bitz
              @comp_bitz ||= collection.rand
            end

            def display
              comp_bitz.display
            end

            def expected
              comp_bitz.expected
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
              collection.correct?(input, comp_bitz)
            end
          end
        end
      end
    end
  end
end
