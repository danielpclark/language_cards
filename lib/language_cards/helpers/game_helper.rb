module LanguageCards
  module Helpers
    module GameHelper
      def calc_score c, i # correct, incorrect
        (0.001+c.to_i)*100.0/(c.to_i+i.to_i+0.001)*1.0
      end
    end
  end
end
