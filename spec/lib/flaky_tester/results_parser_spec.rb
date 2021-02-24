RSpec.describe FlakyTester::ResultsParser do
  describe "#parse" do
    context "when all tests passed" do
      it "returns a success message" do
        results_file = Tempfile.new.tap do |file|
          file.write(File.read("spec/helper_files/success.txt"))
          file.rewind
        end
        results_parser = described_class.new(results_file)

        results_message = results_parser.parse

        expected_message = "Success! All tests passed."

        expect(results_message).to(eq(expected_message))
      end

      it "deletes the results_file" do
        results_file = Tempfile.new.tap do |file|
          file.write(File.read("spec/helper_files/success.txt"))
          file.rewind
        end
        results_parser = described_class.new(results_file)

        allow(File).to(receive(:delete).with(results_file.path))

        results_parser.parse

        expect(File).to(have_received(:delete).with(results_file.path))
      end
    end

    context "when some tests failed" do
      it "returns a failure message" do
        results_file = Tempfile.new.tap do |file|
          file.write(File.read("spec/helper_files/failure.txt"))
          file.rewind
        end
        results_parser = described_class.new(results_file)

        results_message = results_parser.parse

        expected_message = "Oh no... The suite failed 20 times:\n\n".tap do |message|
          message.concat("./spec/flaky_tester_spec.rb:14 failed 9 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:6 failed 8 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:2 failed 8 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:10 failed 7 times.\n")
          message.concat("./spec/flaky_tester_spec.rb:18 failed 6 times.\n\n")
          message.concat("Check the errors in the file:\n")
          message.concat(Pathname.new(results_file.path).relative_path_from(Dir.pwd).to_s)
        end

        expect(results_message).to(eq(expected_message))
      end

      it "keeps the results_file" do
        results_file = Tempfile.new.tap do |file|
          file.write(File.read("spec/helper_files/failure.txt"))
          file.rewind
        end
        results_parser = described_class.new(results_file)

        allow(File).to(receive(:delete).with(results_file.path))

        results_parser.parse

        expect(File).not_to(have_received(:delete).with(results_file.path))
      end
    end
  end
end
