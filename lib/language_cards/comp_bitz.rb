module LanguageCards
  class CompBitz
    attr_reader :display, :collection, :value, :mapping, :key
    def initialize options
      @display = options.fetch(:display)
      @collection = options.fetch(:collection)
      @key = options.fetch(:key)
      @value = options.fetch(:value)
      @mapping = options.fetch(:mapping)
    end
  end
end
