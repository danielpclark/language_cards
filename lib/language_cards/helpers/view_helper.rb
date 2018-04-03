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

      def humanize string
        "#{string}".split('_').map(&:capitalize).join(' ')
      end

      def snake string
        "#{string}".gsub(/(.)([A-Z])/, '\1_\2').downcase
      end

      def wordwrap words
        "#{words}".gsub(/(.{1,#{SUBMENUWIDTH - 7}})(\s+|\Z)/, "\\1\n\t").strip
      end
    end
  end
end
