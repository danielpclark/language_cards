# LanguageCards
[![Gem Version](https://badge.fury.io/rb/language_cards.svg)](https://badge.fury.io/rb/language_cards)
[![Build Status](https://travis-ci.org/danielpclark/language_cards.svg?branch=master)](https://travis-ci.org/danielpclark/language_cards)
[![Build status](https://ci.appveyor.com/api/projects/status/y6jadvlhk50ncbrh?svg=true)](https://ci.appveyor.com/project/danielpclark/language-cards)


This is a flash card game for guessing translations or keyboard learning.  Currently implemented is
English Romaji to Japanese Hirigana/Katakana and typing exercises for each.  Game experience will be improved upon!

Also if your interested in adding other flash cards for language learning, pull requests are welcome.  Please
keep some sort of organized collection for sets of cards (for instance the Japanese-Language Proficiency Test
has different levels to complete, N1 through N5, which would each count as a collection).

Internationalization support is built in!  Translators are welcome to make this game available in other languages.

## Installation

Install it yourself as:

    $ gem install language_cards
    
Or try out the latest master by downloading it: [[master.zip](https://github.com/danielpclark/language_cards/archive/master.zip)]

## Usage

After installing the gem you can run the executable `language_cards`.  If you clone the repo then use
`bundle exec bin/language_cards`.

# Card Format

The cards are stored in YAML format.  You can look in the `cards` directory for existing examples to follow.
The first entry is a language name and it's okay if that already exists in another file.  The entries below that
must be unique for that language (eg: you can't have two Hiragana sub entries on Japanese).  The next step in
will have a mapping hash on how the language is being mapped in the form of key to value (eg "Hiragana" => "Romaji").
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
```

## Development

*Tests required moving forward with this project unless it's translation files.*

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danielpclark/language_cards.
Translations of the game itself are kept in the `locales` folder.  Flash cards are stored in YAML format in the`cards` folder.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

