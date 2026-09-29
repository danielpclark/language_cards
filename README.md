# LanguageCards
[![Gem Version](https://badge.fury.io/rb/language_cards.svg)](https://badge.fury.io/rb/language_cards)
[![CI](https://github.com/danielpclark/language_cards/actions/workflows/ci.yml/badge.svg)](https://github.com/danielpclark/language_cards/actions/workflows/ci.yml)
[![Build status](https://ci.appveyor.com/api/projects/status/y6jadvlhk50ncbrh?svg=true)](https://ci.appveyor.com/project/danielpclark/language-cards)


A terminal flash card game for learning languages that use foreign scripts.  Every language comes with
card sets for its writing system plus vocabulary, and each card set can be played in two modes:

* **Translate**: a card is shown in the foreign script and you type its romanization, reading or English meaning.
* **Typing**: you type the card itself, which is great practice for a foreign-language keyboard or IME.

Japanese is covered from the kana all the way through JLPT N1: every hiragana and katakana (including
combinations, extended katakana and IME keyboard mappings), all 2,211 JLPT N5–N1 kanji and more than 7,800
JLPT N5–N1 vocabulary words.

Included languages (17 languages, 103 card sets, ~17,900 cards):

| Language | Card sets (cards) |
| --- | --- |
| Arabic | Alphabet (31), Numbers (23), Numerals (10), Common Words (245), Phrases (48) |
| Armenian | Alphabet (77), Numbers (23), Common Words (249), Phrases (46) |
| Bengali | Vowels (11), Consonants (39), Numbers (23), Numerals (10), Common Words (249), Phrases (48) |
| Chinese | HSK 1 (150), HSK 2 (147), HSK 3 (298), HSK 4 (598) |
| Georgian | Alphabet (33), Numbers (23), Common Words (250), Phrases (45) |
| Greek | Alphabet (49), Numbers (23), Common Words (247), Phrases (49) |
| Hebrew | Alphabet (22), Final Forms (5), Numbers (23), Common Words (243), Phrases (49) |
| Hindi | Vowels (13), Consonants (44), Vowel Signs (11), Numbers (23), Numerals (10), Common Words (245), Phrases (49) |
| Japanese | Hiragana (46), Hiragana Diacritics (25), Hiragana Combinations (36), Hiragana (All) (108), Katakana (46), Katakana Diacritics (25), Katakana Combinations (36), Katakana Extended (34), Katakana (All) (141), Hiragana Keyboard Mappings (173), Katakana Keyboard Mappings (176), Kanji (JLPT N5) (79), Kanji (JLPT N4) (166), Kanji (JLPT N3) (367), Kanji (JLPT N2) (367), Kanji (JLPT N1) (1232), Vocabulary (JLPT N5) (702), Vocabulary (JLPT N4) (662), Vocabulary (JLPT N3) (2102), Vocabulary (JLPT N2) (1732), Vocabulary (JLPT N1) (2683) |
| Korean | Hangul Consonants (19), Hangul Vowels (21), Hangul Syllables (140), Numbers (45), Common Words (244), Phrases (50) |
| Persian | Alphabet (32), Numbers (23), Numerals (10), Common Words (246), Phrases (46) |
| Punjabi | Letters (41), Vowels (10), Numbers (23), Numerals (10), Common Words (246), Phrases (48) |
| Russian | Alphabet (66), Numbers (23), Common Words (250), Phrases (48) |
| Tamil | Vowels (13), Consonants (23), Syllables (23), Numbers (23), Numerals (10), Common Words (249), Phrases (47) |
| Thai | Consonants (44), Vowels (30), Numbers (23), Numerals (10), Common Words (243), Phrases (43) |
| Ukrainian | Alphabet (66), Numbers (23), Common Words (250), Phrases (48) |
| Urdu | Alphabet (39), Numbers (23), Numerals (10), Common Words (248), Phrases (41) |

Internationalization support is built in!  Translators are welcome to make this game available in other languages.

## Installation

Install it yourself as:

    $ gem install language_cards
    
Or try out the latest master by downloading it: [[master.zip](https://github.com/danielpclark/language_cards/archive/master.zip)]

## Usage

After installing the gem you can run the executable `language_cards`.  If you clone the repo then use
`bundle exec bin/language_cards`.

    $ language_cards --help
    usage: language_cards [options]
        -l, --language  language (default: en)
        -v, --version   print the version
        -h, --help      print this help

Pick a language, then a card set, by typing its number.  Long menus are split into pages of ten.

| Key | Action |
| --- | --- |
| `1`, `2`, ... | Select the numbered language or card set (any number works, not just those on the current page) |
| `n` / `p` | Next / previous page |
| `b` | Back to the language menu |
| `m` | Change game mode (Translate / Typing) |
| `q` | Quit |
| `CTRL-C` | Leave a game and return to the menu (quits from a menu) |

Answers are forgiving: case and extra spaces don't matter, a leading "to " is optional for English verbs
("to eat" and "eat" are both fine), and pinyin can be typed with tone marks (`nǐhǎo`) or tone numbers (`ni3hao3`).

# Card Format

The cards are stored in YAML format in `cards/<interface language>/` (e.g. `cards/en`).  You can look in the
`cards` directory for existing examples to follow.  The first entry is a language name and it's okay if that
already exists in another file; card sets from every file are merged under it.  The entries below that must be
unique for that language (eg: you can't have two Hiragana sub entries on Japanese).  The next step in
will have a mapping hash on how the language is being mapped in the form of key to value (eg "Hiragana" => "Romaji").
Every other entry is a card: the key is what is shown and the value is the answer, or a list of accepted answers.
Just follow the below outline for a working example.

```yaml
---
Japanese:
  Hiragana:
    mapping: { Hiragana: Romaji }
    あ: a
    い: i
    う: u
    え: e
    お: o
    し: [shi, si]
```

Languages are listed alphabetically and card sets in the order they are loaded, with files read in filename
order (which is why the bundled files have numeric prefixes like `japanese-10-kanji-jlpt-n5.yml`).  Quote
answers YAML would otherwise turn into something else, such as `'no'`, `'yes'`, `'on'` or numbers like `'1'`.

You can add your own cards without touching the gem by putting YAML files in `~/.language_cards/cards/en/`.

## Data sources

* JLPT kanji and vocabulary level lists: [Jonathan Waller's JLPT Resources](http://www.tanos.co.uk/jlpt/) (CC BY).
  JLPT levels have been unofficial since 2010, so these lists are a well established approximation.
* Kanji readings were checked against [KANJIDIC](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project) (EDRDG).
* Chinese word lists: the HSK 2.0 official vocabulary lists (levels 1–4).
* Kana: [Wikibooks Japanese kana chart](https://en.wikibooks.org/wiki/Japanese/Kana_chart).

Corrections to any card are very welcome!

## Development

*Tests required moving forward with this project unless it's translation files.*  `test/cards_test.rb`
validates every card file (duplicate keys, empty answers, values YAML would misread), so run the tests after
editing cards too.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danielpclark/language_cards.
Translations of the game itself are kept in the `locales` folder.  Flash cards are stored in YAML format in the`cards` folder.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

