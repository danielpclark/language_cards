module Support
  def self.included(base)
    base.class_exec do
      ##
      # NOTE: keys must use valid I18n translations for testing
      #
      def mapping_key; "Romaji => Hiragana" end
      def map; [{"Romaji" => "Hiragana", "index" => [:k, :v]}] end
      def mapping; LanguageCards::Mappings.new(map, collection) end
      def collection
        c = LanguageCards::CardCollection.new({"mapping" => map, "a" => "ア"})
        c.select_collection(mapping_key)
        c
      end

      def mapping_key2; "Hiragana => Hiragana" end
      def map2; [{"Hiragana" => "Hiragana", "index" => [:v, :v]}] end
      def mapping2; LanguageCards::Mappings.new(map2, collection2) end
      def collection2
        c = LanguageCards::CardCollection.new({"mapping" => map2, "a" => "ア"})
        c.select_collection(mapping_key2)
        c
      end
    end
  end
end
