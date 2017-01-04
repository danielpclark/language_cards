require_relative 'comparator'
require_relative 'mapping'

module LanguageCards
  class CardCollection
    attr_reader :name
    ##
    # RULE: Always compare by value regardless of key value ordering in mapping.
    #    (This allows for duplicate spellings of the same character translation)
    def initialize hsh, name=nil
      @hsh = hsh
      @name = I18n.t "LanguageName.#{name}" if name
      send :_build
      @mappings = @hsh["mapping"]
      if @mappings
        @cards = @hsh.select {|k,v| !v.is_a? Mappings}
      end
    end

    ##
    # Recursively build class course names
    def classes s=nil
      s = @name.nil? ? nil : [s, @name].compact.join(JOIN)
      @hsh.select do |k,v|
        [CardCollection, Mappings].include? v.class
      end.flat_map do |k,v|
        v.send :classes, s
      end
    end

    def [](value)
      raise EmptyCollection unless collection?
      @cards[value]
    end

    def rand
      raise EmptyCollection unless collection?
      v = @cards.keys.sample
      @comparator.given(v, @cards[v])
    end

    def correct? input, comp_bitz
      raise EmptyCollection unless collection?
      @comparator.match? input, comp_bitz
    end

    def mapped_as
      raise EmptyCollection unless collection?
      @comparator.mapped_as
    end

    def children
      @hsh.select {|k,v| v.is_a? CardCollection}.values.map do |cc|
        {cc.name => cc}
      end.inject(:merge)
    end

    def select_collection string
      first, tail = string.split(JOIN, 2)
      if collection?
        @comparator = @mappings.select_mapping(first)
        return self
      else
        children[first].select_collection tail
      end
    end

    def collection?
      !!@cards
    end

    def cards
      @cards || raise(I18n.t 'Errors.UpperCollection')
    end

    private
    ##
    # Replace respective raw ruby object with our objects
    def _build
      if @hsh.has_key? "mapping"
        @hsh["mapping"] = Mappings.new(@hsh["mapping"], self) 
      else
        @hsh.tap do |h|
          h.select {|k,v| v.is_a? Hash }.each do |k,v|
            h[k] = self.class.new(v, k) 
          end
        end
      end
    end

    class EmptyCollection < StandardError
      def initialize
        super(I18n.t 'Errors.EmptyCollection')
      end
    end
  end
end
