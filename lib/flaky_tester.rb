require "flaky_tester/command_parser"
require "flaky_tester/test_runner"
require "flaky_tester/results_parser"

class FlakyTester
  def initialize(command_args = [])
    @command_args = command_args
  end

  def test
    command_parser = CommandParser.new(@command_args)
    command_options = command_parser.parse

    test_runner = TestRunner.new(command_options)
    results_file = test_runner.run

    results_parser = ResultsParser.new(results_file)
    results_message = results_parser.parse

    puts(results_message)
  rescue => error
    puts(error)
    puts(command_parser)
  rescue SystemExit
    # do nothing
  end
end
