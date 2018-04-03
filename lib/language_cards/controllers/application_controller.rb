module LanguageCards
  module Controllers
    class ApplicationController
      include Helpers::ViewHelper

      def render(_binding)
        view = ERB.new IO.read File.expand_path("../view/#{snake name}.erb", __dir__)

        view.result(_binding)
      end

      private
      def name
        self.class.name.split('::').last
      end
    end
  end
end
