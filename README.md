# caveat emptor!
**This gem is not currently on [RubyGems](https://rubygems.org/). I have contacted the developers of the original, unmaintained [`gtin` gem](https://rubygems.org/gems/gtin), requesting to be added as an owner**

# Gtin

![Travis CI build status](https://travis-ci.org/jreut/gtin.svg)

This is a Ruby implementation of the Global Trade Identifier Number. This [global standard](http://www.gs1.org/gtin) is the umbrella covering the more familiar concepts of UPC, EAN, etc.

Although this gem currently supports a small subset of the GTIN standard (let alone the entire GS1 specification), it is still useful, especially in the conversion of UPC-E symbols into their GTIN.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gtin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gtin

## Usage

Start by requiring the gem:

```ruby
require 'gtin'
```

### Constructing a GTIN

GTINs are just plain old `String`s. You can check if a string is a valid GTIN like this:

```ruby
'603675101876'.gtin?          # true
```

You can also construct a GTIN from a raw UPC-E string.

```ruby
Gtin.from_upc_e '08787337'    # '087800000737'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jreut/gtin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

