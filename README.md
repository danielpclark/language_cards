# LanguageCards

This is a flash card game for guessing translations or keyboard learning.  Currently implemented is
English Romaji to Japanese Hirigana/Katakana and typing exercises for each.  Game experience will be improved upon!

Also if your interested in adding other flash cards for language learning, pull requests are welcome.  Please
keep some sort of organized collection for sets of cards (for instance the Japanese-Language Proficiency Test
has different levels to complete, N1 through N5, which would each count as a collection).

Internationalization support is built in!  Translators are welcome to make this game available in other languages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'language_cards'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install language_cards

## Usage

After installing the gem you can run the executable `language_cards`.  If you clone the repo then use
`bin/language_cards`.

## Development

*Tests required moving forward with this project unless it's translation files.*

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danielpclark/language_cards.
Translations of the game itself are kept in the `locales` folder.  Flash cards are stored in YAML format in the`cards` folder.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

