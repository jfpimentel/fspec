require "tempfile"

require_relative "./errors/rspec_error"

class FlakyTester
  class TestRunner
    def initialize
      @results = Tempfile.new
    end

    def run(options)
      command = build_command(options)

      total_runs = options[:times]

      for current_run in (1..total_runs)
        print("Running #{current_run}/#{total_runs}...\r")

        command_succeeded = system(command)

        raise(Errors::RspecError) unless command_succeeded
      end

      @results
    end

    private

    def build_command(options)
      rspec_command = build_rspec_command(options)

      "#{rspec_command} >> \"#{@results.path}\""
    end

    def build_rspec_command(options)
      "bundle exec rspec --no-fail-fast --format progress --profile 0 --failure-exit-code 0 #{options[:path]}"
    end
  end
end
