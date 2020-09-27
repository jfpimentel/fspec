class FlakyTester
  module Errors
    class InvalidTimes < StandardError
      def initialize
        super("Times is not a positive number.")
      end
    end
  end
end
