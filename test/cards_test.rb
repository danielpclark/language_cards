require 'test_helper'
require 'yaml'

# Guards the integrity of every bundled flash card file.
class CardsTest < Minitest::Test
  CARD_FILES = Dir[File.expand_path('../cards/*/*.yml', __dir__)].sort

  def test_card_files_exist
    refute_empty CARD_FILES
  end

  # YAML silently keeps only the last of duplicated keys, which would
  # quietly drop cards, so look for them in the parse tree.
  def test_no_duplicate_keys
    CARD_FILES.each do |file|
      each_mapping(Psych.parse_file(file)) do |mapping|
        keys = mapping.children.each_slice(2).map {|key, _| key.value }
        duplicates = keys.select {|key| keys.count(key) > 1 }.uniq
        assert_empty duplicates, "Duplicate keys in #{File.basename(file)}"
      end
    end
  end

  def test_card_structure
    CARD_FILES.each do |file|
      name = File.basename(file)
      data = YAML.safe_load(File.read(file, encoding: 'UTF-8'))
      assert_kind_of Hash, data, name

      data.each do |language, card_sets|
        assert_kind_of String, language, name
        assert_kind_of Hash, card_sets, "#{name}: #{language}"

        card_sets.each do |set_name, cards|
          where = "#{name}: #{language} - #{set_name}"
          assert_kind_of String, set_name, where
          assert_kind_of Hash, cards, where
          assert cards.key?('mapping'), "#{where} has no mapping"

          flash_cards = cards.reject {|key, _| key == 'mapping' }
          refute_empty flash_cards, where

          flash_cards.each do |key, answers|
            # Unquoted yes/no/on/off/numbers become non-strings in YAML
            assert_kind_of String, key, "#{where}: key #{key.inspect}"
            answers = Array(answers)
            refute_empty answers, "#{where}: #{key} has no answers"
            answers.each do |answer|
              assert_kind_of String, answer, "#{where}: #{key} => #{answer.inspect}"
              refute_empty answer.strip, "#{where}: #{key} has a blank answer"
            end
          end
        end
      end
    end
  end

  def test_all_card_sets_load_into_menu
    menu = LanguageCards.menu_builder(LanguageCards::YAMLLoader.new.load)
    languages = menu.map {|item| item.label.first }.uniq

    %w[Japanese Chinese].each do |language|
      assert_includes languages, language
    end

    menu.each do |item|
      assert item.size > 0, "#{item} is empty"
      game = item.game(:translate)
      game.sample
      assert game.match?(game.current.translation.first), "#{item}: #{game.current}"
    end
  end

  def test_japanese_kana_is_complete
    japanese = LanguageCards::YAMLLoader.new.load['Japanese']
    hiragana = japanese['Hiragana (All)'].keys.join
    katakana = japanese['Katakana (All)'].keys.join

    ('ぁ'..'ゔ').each do |kana|
      next if 'ぁぃぅぇぉっゃゅょゎゐゑ'.include?(kana)
      assert_includes hiragana, kana
      katakana_kana = (kana.ord + 0x60).chr(Encoding::UTF_8)
      assert_includes katakana, katakana_kana
    end
  end

  private
  def each_mapping(node, &block)
    yield node if node.is_a?(Psych::Nodes::Mapping)
    Array(node.children).each {|child| each_mapping(child, &block) }
  end
end
