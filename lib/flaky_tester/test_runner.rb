require "tempfile"

require_relative "./errors/rspec_error"

class FlakyTester
  class TestRunner
    def initialize
      @results_file = Tempfile.new
    end

    def run(command_options)
      command = build_command(command_options)

      total_runs = command_options[:times]

      for current_run in (1..total_runs)
        print("Running #{current_run}/#{total_runs}...\r")

        command_succeeded = system(command)

        raise(Errors::RspecError) unless command_succeeded
      end

      @results_file
    end

    private

    def build_command(command_options)
      rspec_command = build_rspec_command(command_options)

      "#{rspec_command} >> \"#{@results_file.path}\""
    end

    def build_rspec_command(command_options)
      "bundle exec rspec --no-fail-fast --format progress --profile 0 --failure-exit-code 0 #{command_options[:path]}"
    end
  end
end
