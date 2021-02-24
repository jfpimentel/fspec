RSpec.describe FlakyTester::TestRunner do
  describe "#run" do
    context "when command_options = {times: 11, path: './spec'}", :stdout_off, :delete_file do
      context "when the system call returns true" do
        it "executes the rspec command 11 times for the path './spec'" do
          command_options = {times: 11, path: "./spec"}
          test_runner = described_class.new(command_options)

          allow(test_runner).to(receive(:system).and_return(true))

          results_file = test_runner.run

          expect(test_runner).to(have_received(:system).exactly(command_options[:times]).times.with(
            a_string_matching("bundle exec rspec( -(-\\w+)+( \\w+)*)* #{command_options[:path]} >> \"#{results_file.path}\"")
          ))
        end

        it "returns the results_file" do
          command_options = {times: 11, path: "./spec"}
          test_runner = described_class.new(command_options)

          allow(test_runner).to(receive(:system).and_return(true))

          results_file = test_runner.run

          expect(results_file).to(be_a(File))
        end
      end

      context "when the system call returns false" do
        it "raises an rspec_error error" do
          command_options = {times: 11, path: "./spec"}
          test_runner = described_class.new(command_options)

          allow(test_runner).to(receive(:system).and_return(false))

          expect{test_runner.run}.to(raise_error(described_class::Errors::RspecError))
        end
      end
    end
  end
end
