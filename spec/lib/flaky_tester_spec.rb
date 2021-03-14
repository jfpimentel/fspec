RSpec.describe FlakyTester do
  describe "#test" do
    it "outputs the results_message" do
      command_options = {}
      results_file = Tempfile.new
      results_message = "All tests passed!"

      command_parser = double("command_parser", parse: command_options)
      test_runner = double("test_runner", run: results_file)
      results_parser = double("results_parser", parse: results_message)

      allow(described_class::CommandParser).to(receive(:new).and_return(command_parser))
      allow(described_class::TestRunner).to(receive(:new).and_return(test_runner))
      allow(described_class::ResultsParser).to(receive(:new).and_return(results_parser))

      expect{described_class.new.test}.to(
        output("#{results_message}\n").to_stdout
      )
    end

    context "when CommandParser#parse raises an error" do
      it "outputs the error and the command instructions" do
        error_message = "An error occurred!"
        command_parser = double("command_parser")

        allow(command_parser).to(receive(:parse).and_raise(StandardError, error_message))
        allow(described_class::CommandParser).to(receive(:new).and_return(command_parser))

        expect{described_class.new.test}.to(
          output("#{error_message}\n#{command_parser}\n").to_stdout
        )
      end
    end

    context "when CommandParser#parse raises a system_exit exception" do
      it "rescues the exception" do
        command_parser = double("command_parser")

        allow(command_parser).to(receive(:parse).and_raise(SystemExit))
        allow(described_class::CommandParser).to(receive(:new).and_return(command_parser))

        expect{described_class.new.test}.not_to(raise_error)
      end
    end
  end
end
