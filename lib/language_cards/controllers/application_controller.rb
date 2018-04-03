module LanguageCards
  module Controllers
    class ApplicationController
      include Helpers::ViewHelper

      def render(_binding)
        view = File.expand_path("../view/#{snake name}.erb", __dir__).
          ᐅ( IO.method :read ).
          ᐅ ERB.method :new

        view.result(_binding)
      end

      private
      def name
        self.class.name.split('::').last
      end
    end
  end
end
