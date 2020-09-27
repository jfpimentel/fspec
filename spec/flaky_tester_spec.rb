RSpec.describe FlakyTester do
  describe ".call" do
    it "returns nil" do
      expect(described_class.call).to eq(nil)
    end
  end
end
