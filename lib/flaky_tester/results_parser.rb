class FlakyTester
  class ResultsParser
    FAILED_SUITE_REGEX = /^Failures:$/.freeze
    FAILED_TEST_REGEX = /^rspec (.+:\d+) # .+$/.freeze

    def initialize
      @failed_suite_count = 0
      @failed_test_counts = {}
    end

    def parse(results)
      File.open(results) do |file|
        file.each do |line|
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
      end

      message
    ensure
      results.close
      results.unlink
    end

    private

    def message
      return "Success! The suite failed 0 times." if @failed_suite_count == 0

      message = "Oh no... The suite failed #{@failed_suite_count} times:"

      sorted_failed_test_counts = @failed_test_counts.sort_by { |_, count| -count }.to_h

      sorted_failed_test_counts.each_with_object(message) do |(failed_test, count), message|
        message.concat("\n#{failed_test} failed #{count} times.")
      end
    end
  end
end