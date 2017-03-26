module LanguageCards
  class CompBitz
    attr_reader :display, :collection, :value, :mapping, :expected
    def initialize options
      @display = options.fetch(:display).freeze
      @collection = options.fetch(:collection).freeze
      @expected = options.fetch(:expected).freeze
      @value = options.fetch(:value).freeze
      @mapping = options.fetch(:mapping).freeze
      self.freeze
    end
  end
end
