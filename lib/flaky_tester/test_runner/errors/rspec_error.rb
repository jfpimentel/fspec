class FlakyTester
  class TestRunner
    class Errors
      class RspecError < StandardError
        def initialize
          super("RSpec failed to run.")
        end
      end
    end
  end
end
