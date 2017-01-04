require_relative 'comp_bitz'

module LanguageCards
  class Comparator
    def initialize mapping_key, mapping, collection
      ##
      # @title should be a hash like {"Romaji"=>"Katakana"}
      # @mapping should be an array like [:k, :v]
      @mapped_as, @mapping = mapping[mapping_key].reduce
      @collection = collection
    end

    def mapped_as
      case @mapping.first
      when :k
        @mapped_as.keys
      else
        @mapped_as.values
      end
    end

    def given key, value
      CompBitz.new(
        display: choose(key, value),
        collection: @collection,
        value: value,
        mapping: @mapping.first
      )
    end

    def match? input, comp_bitz
      case comp_bitz.mapping 
      when :k
        comp_bitz.value == comp_bitz.collection[input]
      when :v
        comp_bitz.value == input
      end
    end

    private
    def choose key, value
      case @mapping.last
      when :k
        key
      when :v
        value
      end
    end
  end
end

