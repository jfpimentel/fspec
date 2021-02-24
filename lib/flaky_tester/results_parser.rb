class FlakyTester
  class ResultsParser
    FAILED_SUITE_REGEX = /^Failures:$/.freeze
    FAILED_TEST_REGEX = /^rspec (.+:\d+) # .+$/.freeze

    def initialize(results_file)
      @results_file = results_file
      @failed_suite_count = 0
      @failed_test_counts = {}
    end

    def parse
      @results_file.each do |line|
        failed_suite_match_data = FAILED_SUITE_REGEX.match(line)

        if failed_suite_match_data
          @failed_suite_count += 1
          next
        end

        failed_test_match_data = FAILED_TEST_REGEX.match(line)

        if failed_test_match_data
          failed_test = failed_test_match_data[1]
          @failed_test_counts[failed_test] ||= 0
          @failed_test_counts[failed_test] += 1
        end
      end

      results_message
    ensure
      close_results_file
    end

    private

    def results_message
      return "Success! All tests passed." if zero_failures?

      message = "Oh no... The suite failed #{@failed_suite_count} times:\n"

      sorted_failed_test_counts = @failed_test_counts.sort_by { |_, count| -count }.to_h

      sorted_failed_test_counts.each_with_object(message) do |(failed_test, count), message|
        message.concat("\n#{failed_test} failed #{count} times.")
      end

      message.concat("\n\nCheck the errors in the file:\n")
      message.concat(Pathname.new(@results_file.path).relative_path_from(Dir.pwd).to_s)
    end

    def close_results_file
      @results_file.close

      if zero_failures?
        File.delete(@results_file.path)
      end
    end

    def zero_failures?
      @failed_suite_count == 0
    end
  end
end
