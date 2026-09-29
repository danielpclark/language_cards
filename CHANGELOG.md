# Changelog

## 1.0.0

### Card data
* Japanese, now fully covered:
  * Hiragana and Katakana split into basic, diacritics (dakuten/handakuten), combinations (yōon) and "All"
    sets, plus Extended Katakana for foreign sounds.  Romaji answers accept both Hepburn and Kunrei-shiki.
  * Hiragana keyboard mappings added next to the existing Katakana keyboard mappings.
  * Kanji for every JLPT level N5 through N1 (2,211 kanji), with readings in hiragana and English meanings.
  * Vocabulary for every JLPT level N5 through N1 (7,800+ words).
* Chinese: HSK 1–4 (1,193 words), answered in pinyin with tone marks, tone numbers or in English.
  Fixes several wrong pinyin in the old HSK 1 set, and the language is now named "Chinese".
* New languages: Arabic, Armenian, Bengali, Georgian, Greek, Hebrew, Hindi, Korean, Persian, Punjabi,
  Russian, Tamil, Thai, Ukrainian and Urdu, each with writing-system sets plus numbers, common words
  and phrases.

### Game
* Two-level menu: pick a language first, then one of its card sets.  Menus are paginated (10 per page,
  `n`/`p` to page, `b` to go back, `q` to quit) and show how many sets/cards each entry has.
* Translate answers are case-insensitive, ignore extra whitespace and Unicode composition differences, and
  treat a leading "to " as optional.
* Numeric answers in card files (e.g. `1`) now match what is typed.
* The score and timer reset for each game, and the same card is never shown twice in a row.
* CTRL-C in a game returns to the card set menu; end of input exits cleanly.
* New `--version` and `--help` command line flags.

### Maintenance
* Runs on modern Ruby: updated to HighLine 2/3 and i18n 1.x.
* Card files are validated by the test suite (duplicate keys, empty answers, values YAML would misread).
* GitHub Actions CI replaces Travis CI.
