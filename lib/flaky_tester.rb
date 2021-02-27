require "flaky_tester/command_parser"
require "flaky_tester/test_runner"
require "flaky_tester/results_parser"

class FlakyTester
  DEFAULT_COMMAND_OPTIONS = {
    times: 25,
    path: ""
  }.freeze

  def self.test(command_args = [])
    new.test(command_args)
  end

  def test(command_args)
    command_parser = CommandParser.new
    command_options = command_parser.parse(command_args)

    test_runner = TestRunner.new
    results_file = test_runner.run(command_options)

    results_parser = ResultsParser.new
    results_message = results_parser.parse(results_file)

    puts(results_message)
  rescue => error
    puts(error)
    puts(command_parser)
  rescue SystemExit
    # do nothing
  end
end
