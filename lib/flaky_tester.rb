require "flaky_tester/command_parser"
require "flaky_tester/test_runner"
require "flaky_tester/results_parser"

class FlakyTester
  DEFAULT_OPTIONS = {
    times: 25,
    path: ""
  }.freeze

  def self.test(args = [])
    new.test(args)
  end

  def test(args)
    command_parser = CommandParser.new
    options = command_parser.parse(args)

    test_runner = TestRunner.new
    results = test_runner.run(options)

    results_parser = ResultsParser.new
    message = results_parser.parse(results)

    puts(message)
  rescue => error
    puts(error)
    puts(command_parser)
  rescue SystemExit
    # do nothing
  end
end
