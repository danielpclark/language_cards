module LanguageCards
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

    def has_key? key
      @mappings.has_key? key
    end

    def keys
      @mappings.keys
    end

    class InvalidMapping < StandardError
      def initialize
        super(I18n.t 'Errors.InvalidMapping')
      end
    end

  end
end
