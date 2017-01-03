require "language_cards/version"
require 'yaml'
require 'i18n'
require 'highline'

module LanguageCards
  CLEAR = "\e[3J\e[H\e[2J"
  CLI = HighLine.new
  JOIN = " : "

  ::I18n.load_path = Dir[File.join 'locales', '*.yml']

  def self.start
    LanguageCards.new.start_menu
  end

  class LanguageCards
    def initialize
      @CARDS = {}
      Dir[File.join 'cards', '*.yml'].each do |c|
        @CARDS.merge!(YAML.load(File.open(c).read))
      end
      @CARDS = CardCollection.new @CARDS
    end
    
    def start_menu
      loop do
        clear
        puts I18n.t 'StartMenu.Title'
        opt = CLI.choose do |menu|
          menu.prompt = I18n.t 'StartMenu.Choose'
          @CARDS.classes.each do |item|
            menu.choice(item) 
          end
          menu.choices(:exit)
        end
        break if opt == :exit
        collection = @CARDS.select_collection(opt)
        comp_bitz = collection.rand
        input = CLI.ask("#{I18n.t('Game.TypeThis')} #{collection.mapped_as}: #{comp_bitz.display}")
        if collection.correct? input, comp_bitz
          CLI.say "You have won a cookie!"
          sleep 2
        else
          CLI.say "You have failed this PTY!"
          sleep 2
        end
      end
    end

    private
    ##
    # TODO: Check local operating system for clear or cls command and dynamically define this method via
    #       that commands output.
    def clear
      printf CLEAR
    end
  end

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
      raise "Invalid option on empty card collection" unless collection?
      @cards[value]
    end

    def rand
      raise "Invalid option on empty card collection" unless collection?
      v = @cards.keys.sample
      @comparator.given(v, @cards[v])
    end

    def correct? input, comp_bitz
      raise "Invalid option on empty card collection" unless collection?
      @comparator.match? input, comp_bitz
    end

    def mapped_as
      raise "Invalid option on empty card collection" unless collection?
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

    class Comparator
      attr_reader :mapped_as
      def initialize mapping_key, mapping, collection
        ##
        # @title should be a hash like {"Romaji"=>"Katakana"}
        # @mapping should be an array like [:k, :v]
        @mapped_as, @mapping = mapping[mapping_key].reduce
        @collection = collection
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

    class Mappings
      def initialize mapping, collection=nil
        @collection = collection
        @mappings = {}
        mapping.each do |h|
          index = h.delete("index")
          begin
            a,b = h.reduce
          rescue LocalJumpError
            raise InvalidMapping
          end
          a = I18n.t "LanguageName.#{a}"
          b = I18n.t "LanguageName.#{b}"

          @mappings["#{a} => #{b}"] = {
            h => index
          }
        end
      end

      def select_mapping string
        Comparator.new string, self, @collection
      end

      def classes s=nil
        keys.map do |names|
          [s, names].compact.join(JOIN)
        end
      end

      def [] key
        @mappings[key]
      end

      def order key # what was my intention in design here?
        self[key].values.flatten
      end

      def keys
        @mappings.keys
      end

      def inspect
        @mappings.keys
      end

      class InvalidMapping < StandardError
        def initialize
          super(I18n.t 'Errors.InvalidMapping')
        end
      end
    end
  end
end
