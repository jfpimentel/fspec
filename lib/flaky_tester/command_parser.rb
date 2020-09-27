require "optparse"

require_relative "./errors/invalid_times"
require_relative "./errors/unknown_path"

class FlakyTester
  class CommandParser
    def initialize
      @options = DEFAULT_OPTIONS.dup

      @option_parser = OptionParser.new do |option_parser|
        option_parser.banner = "Usage: fspec [options]"

        option_message = "Number of times to run the test suite (default: #{DEFAULT_OPTIONS[:times]})"
        option_parser.on("-t", "--times TIMES", option_message) do |times|
          raise(Errors::InvalidTimes) unless valid_times?(times)
          @options[:times] = times.to_i
        end

        option_message = "Relative path containing the tests to run (default: RSpec's default)"
        option_parser.on("-p", "--path PATH", option_message) do |path|
          raise(Errors::UnknownPath) unless valid_path?(path)
          @options[:path] = path
        end

        option_parser.on("-h", "--help", "Prints command instructions") do
          puts(option_parser)
          exit
        end
      end
    end

    def parse(args)
      @option_parser.parse!(args)
      @options
    end

    def to_s
      @option_parser.to_s
    end

    private

    def valid_times?(times)
      /^[1-9]\d*$/.match(times)
    end

    def valid_path?(path)
      File.file?(path) || File.directory?(path)
    end
  end
end
