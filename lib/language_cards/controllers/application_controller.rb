module LanguageCards
  module Controllers
    class ApplicationController
      include Helpers::ViewHelper

      def initialize(opts = {})
        @opts = opts
      end

      def render(_binding)
        view = ERB.new IO.read File.expand_path("../view/#{snake name}.erb", __dir__)

        view.result(_binding)
      end

      private
      attr_reader :opts
      def name
        self.class.name.split('::').last
      end

      def errors
        Array(opts[:errors])
      end
    end
  end
end
