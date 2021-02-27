require "optparse"

require_relative "./errors/invalid_times"
require_relative "./errors/unknown_path"

class FlakyTester
  class CommandParser
    def initialize(command_args = [])
      @command_args = command_args
      @command_options = DEFAULT_COMMAND_OPTIONS.dup
      @option_parser = OptionParser.new do |option_parser|
        option_parser.banner = "Usage: fspec [options]"
      end

      set_times_option_handler
      set_path_option_handler
      set_help_option_handler
    end

    def parse
      @option_parser.parse!(@command_args)
      @command_options
    end

    def to_s
      @option_parser.to_s
    end

    private

    def set_times_option_handler
      option_message = "Number of times to run the test suite (default: #{DEFAULT_COMMAND_OPTIONS[:times]})"
      @option_parser.on("-t", "--times TIMES", option_message) do |times|
        raise(Errors::InvalidTimes) unless valid_times?(times)
        @command_options[:times] = times.to_i
      end
    end

    def set_path_option_handler
      option_message = "Relative path containing the tests to run (default: RSpec's default)"
      @option_parser.on("-p", "--path PATH", option_message) do |path|
        raise(Errors::UnknownPath) unless valid_path?(path)
        @command_options[:path] = path
      end
    end

    def set_help_option_handler
      @option_parser.on("-h", "--help", "Prints command instructions") do
        puts(@option_parser)
        exit
      end
    end

    def valid_times?(times)
      /^[1-9]\d*$/.match(times)
    end

    def valid_path?(path)
      File.file?(path) || File.directory?(path)
    end
  end
end
