module LanguageCards
  class CompBitz
    attr_reader :display, :collection, :value, :mapping
    def initialize options
      @display = options.fetch(:display)
      @collection = options.fetch(:collection)
      @value = options.fetch(:value)
      @mapping = options.fetch(:mapping)
    end
  end
end
