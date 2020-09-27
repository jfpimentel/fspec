class FlakyTester
  module Errors
    class RspecError < StandardError
      def initialize
        super("RSpec failed to run.")
      end
    end
  end
end
