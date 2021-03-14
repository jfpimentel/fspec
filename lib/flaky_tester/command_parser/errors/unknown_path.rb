class FlakyTester
  class CommandParser
    class Errors
      class UnknownPath < StandardError
        def initialize
          super("Path does not exist.")
        end
      end
    end
  end
end
