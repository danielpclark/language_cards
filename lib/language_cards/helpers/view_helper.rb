module LanguageCards
  module Helpers
    module ViewHelper
      def divider
        '~' * SUBMENUWIDTH
      end

      def t str
        I18n.t str
      end

      def draw left=nil, center=nil, right=nil
        width = SUBMENUWIDTH
        str = left.to_s
        str = str + center.to_s.rjust(width/2 - str.length + center.to_s.length/2)
        str + right.to_s.rjust(width - str.length)
      end

      def clear
        printf ::LanguageCards::ESC::CLEAR
      end
    end
  end
end
