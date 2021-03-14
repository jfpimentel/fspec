RSpec.describe FlakyTester::CommandParser do
  describe "#parse" do
    context "when command_args = nil" do
      it "returns the DEFAULT_COMMAND_OPTIONS" do
        command_parser = described_class.new

        expect(command_parser.parse).to(eq(described_class::DEFAULT_COMMAND_OPTIONS))
      end
    end

    context "when command_args = ['-t', 'invalid']" do
      it "raises an invalid_times error" do
        command_args = ["-t", "invalid"]
        command_parser = described_class.new(command_args)

        expect{command_parser.parse}.to(raise_error(described_class::Errors::InvalidTimes))
      end
    end

    context "when command_args = ['--times', 'invalid']" do
      it "raises an invalid_times error" do
        command_args = ["--times", "invalid"]
        command_parser = described_class.new(command_args)

        expect{command_parser.parse}.to(raise_error(described_class::Errors::InvalidTimes))
      end
    end

    context "when command_args = ['-t', '123']" do
      it "returns the command_options with the times option set to 123" do
        command_args = ["-t", "123"]
        command_parser = described_class.new(command_args)

        expect(command_parser.parse).to(match(a_hash_including(times: 123)))
      end
    end

    context "when command_args = ['--times', '123']" do
      it "returns the command_options with the times option set to 123" do
        command_args = ["--times", "123"]
        command_parser = described_class.new(command_args)

        expect(command_parser.parse).to(match(a_hash_including(times: 123)))
      end
    end

    context "when command_args = ['-p', 'invalid']" do
      it "raises an unknown_path error" do
        command_args = ["-p", "invalid"]
        command_parser = described_class.new(command_args)

        expect{command_parser.parse}.to(raise_error(described_class::Errors::UnknownPath))
      end
    end

    context "when command_args = ['--path', 'invalid']" do
      it "raises an unknown_path error" do
        command_args = ["--path", "invalid"]
        command_parser = described_class.new(command_args)

        expect{command_parser.parse}.to(raise_error(described_class::Errors::UnknownPath))
      end
    end

    context "when command_args = ['-p', './spec']" do
      it "returns the command_options with the path option set to './spec'" do
        command_args = ["-p", "./spec"]
        command_parser = described_class.new(command_args)

        expect(command_parser.parse).to(match(a_hash_including(path: "./spec")))
      end
    end

    context "when command_args = ['--path', './spec']" do
      it "returns the command_options with the path option set to './spec'" do
        command_args = ["--path", "./spec"]
        command_parser = described_class.new(command_args)

        expect(command_parser.parse).to(match(a_hash_including(path: "./spec")))
      end
    end

    context "when command_args = ['-h']", :stdout_off do
      it "raises a system_exit exception" do
        command_args = ["-h"]
        command_parser = described_class.new(command_args)

        expect{command_parser.parse}.to(raise_error(SystemExit))
      end
    end

    context "when command_args = ['--help']", :stdout_off do
      it "raises a system_exit exception" do
        command_args = ["--help"]
        command_parser = described_class.new(command_args)

        expect{command_parser.parse}.to(raise_error(SystemExit))
      end
    end
  end

  describe "#to_s" do
    it "returns the command instructions" do
      command_parser = described_class.new

      expect(command_parser.to_s).to(
        eq(
          <<~STRING
            Usage: fspec [options]
                -t, --times TIMES                Number of times to run the test suite (default: 25)
                -p, --path PATH                  Relative path containing the tests to run (default: RSpec's default)
                -h, --help                       Prints command instructions
          STRING
        )
      )
    end
  end
end
