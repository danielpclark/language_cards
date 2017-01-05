module LanguageCards
  class CompBitz
    attr_reader :display, :collection, :value, :mapping, :expected
    def initialize options
      @display = options.fetch(:display)
      @collection = options.fetch(:collection)
      @expected = options.fetch(:expected)
      @value = options.fetch(:value)
      @mapping = options.fetch(:mapping)
    end
  end
end
