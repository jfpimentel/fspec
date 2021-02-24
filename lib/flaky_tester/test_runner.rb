require "fileutils"

require_relative "./test_runner/errors/rspec_error"

class FlakyTester
  class TestRunner
    def initialize(command_options)
      @command_options = command_options
      @results_file = build_results_file
    end

    def run
      total_runs = @command_options[:times]

      for current_run in (1..total_runs)
        print("Running #{current_run}/#{total_runs}...\r")

        command_succeeded = system(command)

        raise(Errors::RspecError) unless command_succeeded
      end

      @results_file
    end

    private

    def build_results_file
      dir_name = "tmp"
      dir_path = File.join(Dir.pwd, dir_name)

      file_name = "fspec@#{Time.now.strftime("%Y%m%d%H%M%S")}.txt"
      file_path = File.join(Dir.pwd, dir_name, file_name)

      FileUtils.mkpath(dir_path)
      File.new(file_path, "w+")
    end

    def command
      "#{rspec_command} >> \"#{@results_file.path}\""
    end

    def rspec_command
      "bundle exec rspec --no-fail-fast --format progress --profile 0 --failure-exit-code 0 #{@command_options[:path]}"
    end
  end
end
