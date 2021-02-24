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

If any test fails, the result message will be:

  % fspec
  Oh no... The suite failed 17 times:

  ./spec/models/user_spec.rb:62 failed 13 times.
  ./spec/models/user_spec.rb:24 failed 12 times.

  Check the errors in the file:
  tmp/fspec@20210314191550.txt

If all tests pass, the result message will be:

  % fspec
  Success! All tests passed.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
