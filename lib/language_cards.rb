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
      clear
      puts I18n.t 'StartMenu.Title'
      opt = CLI.choose do |menu|
        menu.prompt = I18n.t 'StartMenu.Choose'
        @CARDS.classes.each do |item|
          menu.choice(item) 
        end
        menu.default = 0
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

    def children
      @hsh.select {|k,v| v.is_a? CardCollection}.values.map do |cc|
        {cc.name => cc}
      end.inject(:merge)
    end

    def select_collection string
      lang, rest = string.split(JOIN, 2)
      if collection?
        @mapping_choice = rest
        return self
      else
        children[lang].select_collection rest
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
        @hsh["mapping"] = Mappings.new(@hsh["mapping"]) 
      else
        @hsh.tap do |h|
          h.select {|k,v| v.is_a? Hash }.each do |k,v|
            h[k] = self.class.new(v, k) 
          end
        end
      end
    end

    class Comparator
      def initialize mapping_key, mapping
        ##
        # @title should be a hash like {"Romaji"=>"Katakana"}
        # @mapping should be an array like [:k, :v]
        @title, @mapping = mapping[mapping_key]
      end

    end

    class Mappings
      def initialize mapping
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
