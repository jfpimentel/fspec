# FSpec

Runs RSpec suite multiple times to find flaky tests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fspec"
```

And then execute:

    % bundle install

Or install it yourself as:

    % gem install fspec

## Usage

	% fspec [options]

	-t, --times TIMES    Number of times to run the test suite (default: 25)
	-p, --path PATH      Relative path containing the tests to run (default: RSpec's default)
	-h, --help           Prints command instructions

The example below runs the model tests one hundred times:

	% fspec -p spec/models -t 100

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
