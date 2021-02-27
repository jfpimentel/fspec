RSpec.describe FlakyTester do
  context "when no options are passed" do
    it "calls test_runner with the default options" do
      allow(described_class::TestRunner).to(receive(:new))
      allow($stdout).to(receive(:puts)) # stubbing puts to avoid printing messages

      described_class.new.test

      expect(described_class::TestRunner).to(
        have_received(:new).with(described_class::DEFAULT_COMMAND_OPTIONS)
      )
    end

    context "when there aren't any failures" do
      it "outputs a success message" do
        results_file = Tempfile.new.tap do |file|
          file.write(File.read("spec/helper_files/success.txt"))
          file.close
        end

        test_runner = double("test_runner", run: results_file)
        allow(described_class::TestRunner).to(receive(:new).and_return(test_runner))

        expected_message = "Success! All tests passed.\n"

        expect{described_class.new.test}.to(output(expected_message).to_stdout)
      end
    end

    context "when there are failures" do
      it "outputs a failure message" do
        results_file = Tempfile.new.tap do |file|
          file.write(File.read("spec/helper_files/failure.txt"))
          file.close
        end

        test_runner = double("test_runner", run: results_file)
        allow(described_class::TestRunner).to(receive(:new).and_return(test_runner))

        expected_message = "Oh no... The suite failed 20 times:\n".tap do |message|
          message.concat("./spec/flaky_tester_spec.rb:14 failed 9 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:6 failed 8 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:2 failed 8 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:10 failed 7 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:18 failed 6 times.\n")
        end

        expect{described_class.new.test}.to(output(expected_message).to_stdout)
      end
    end
  end

  context "when passing the option: -t invalid" do
    it "outputs the invalid_times error and the command instructions" do
      error_message = described_class::Errors::InvalidTimes.new.to_s
      command_instructions = described_class::CommandParser.new.to_s

      expect{described_class.new(["-t", "invalid"]).test}.to(
        output("#{error_message}\n#{command_instructions}").to_stdout
      )
    end
  end

  context "when passing the option: --times invalid" do
    it "outputs the invalid_times error and the command instructions" do
      error_message = described_class::Errors::InvalidTimes.new.to_s
      command_instructions = described_class::CommandParser.new.to_s

      expect{described_class.new(["--times", "invalid"]).test}.to(
        output("#{error_message}\n#{command_instructions}").to_stdout
      )
    end
  end

  context "when passing the option: -t 123" do
    it "calls test_runner with the times option set to 123" do
      allow(described_class::TestRunner).to(receive(:new))
      allow($stdout).to(receive(:puts)) # stubbing puts to avoid printing messages

      described_class.new(["-t", "123"]).test

      expect(described_class::TestRunner).to(
        have_received(:new).with(a_hash_including(times: 123))
      )
    end
  end

  context "when passing the option: --times 123" do
    it "calls test_runner with the times option set to 123" do
      allow(described_class::TestRunner).to(receive(:new))
      allow($stdout).to(receive(:puts)) # stubbing puts to avoid printing messages

      described_class.new(["--times", "123"]).test

      expect(described_class::TestRunner).to(
        have_received(:new).with(a_hash_including(times: 123))
      )
    end
  end

  context "when passing the option: -p invalid" do
    it "outputs the unknown_path error and the command instructions" do
      error_message = described_class::Errors::UnknownPath.new.to_s
      command_instructions = described_class::CommandParser.new.to_s

      expect{described_class.new(["-p", "invalid"]).test}.to(
        output("#{error_message}\n#{command_instructions}").to_stdout
      )
    end
  end

  context "when passing the option: --path invalid" do
    it "outputs the unknown_path error and the command instructions" do
      error_message = described_class::Errors::UnknownPath.new.to_s
      command_instructions = described_class::CommandParser.new.to_s

      expect{described_class.new(["--path", "invalid"]).test}.to(
        output("#{error_message}\n#{command_instructions}").to_stdout
      )
    end
  end

  context "when passing the option: -p ./spec" do
    it "calls test_runner with the path option set to ./spec" do
      allow(described_class::TestRunner).to(receive(:new))
      allow($stdout).to(receive(:puts)) # stubbing puts to avoid printing messages

      described_class.new(["-p", "./spec"]).test

      expect(described_class::TestRunner).to(
        have_received(:new).with(a_hash_including(path: "./spec"))
      )
    end
  end

  context "when passing the option: --path ./spec" do
    it "calls test_runner with the path option set to ./spec" do
      allow(described_class::TestRunner).to(receive(:new))
      allow($stdout).to(receive(:puts)) # stubbing puts to avoid printing messages

      described_class.new(["--path", "./spec"]).test

      expect(described_class::TestRunner).to(
        have_received(:new).with(a_hash_including(path: "./spec"))
      )
    end
  end

  context "when passing the option: -h" do
    it "outputs the command instructions" do
      command_instructions = described_class::CommandParser.new.to_s

      expect{described_class.new(["-h"]).test}.to(
        output(command_instructions).to_stdout
      )
    end
  end

  context "when passing the option: --help" do
    it "outputs the command instructions" do
      command_instructions = described_class::CommandParser.new.to_s

      expect{described_class.new(["--help"]).test}.to(
        output(command_instructions).to_stdout
      )
    end
  end

  context "when CommandParser#parse raises an error" do
    it "outputs the error and the command instructions" do
      error_message = "An error occurred!"
      command_parser = described_class::CommandParser.new
      command_instructions = command_parser.to_s

      allow(command_parser).to(receive(:parse).and_raise(StandardError, error_message))
      allow(described_class::CommandParser).to(receive(:new).and_return(command_parser))

      expect{described_class.new.test}.to(
        output("#{error_message}\n#{command_instructions}").to_stdout
      )
    end
  end

  context "when TestRunner#system returns false" do
    it "outputs the rspec_error error and the command instructions" do
      error_message = described_class::Errors::RspecError.new.to_s
      command_instructions = described_class::CommandParser.new.to_s

      test_runner = described_class::TestRunner.new
      allow(test_runner).to(receive(:print)) # stubbing print to avoid printing the progress message
      allow(test_runner).to(receive(:system).and_return(false))
      allow(described_class::TestRunner).to(receive(:new).and_return(test_runner))

      expect{described_class.new.test}.to(
        output("#{error_message}\n#{command_instructions}").to_stdout
      )
    end
  end
end
