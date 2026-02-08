require "rails_helper"

RSpec.describe Region, type: :model do
  describe "factory" do
    it "builds a Region" do
      expect(build(:region)).to be_a(Region)
    end
  end

  describe "#to_s" do
    it "returns its name" do
      region = build(:region, name: "Some other name")
      expect(region.to_s).to eq("Some other name")
    end
  end

  describe ".unspecified" do
    it "returns a Region" do
      expect(Region.unspecified).to be_a(Region)
    end

    it "is idempotent (returns the same record each time)" do
      r1 = Region.unspecified
      r2 = Region.unspecified
      expect(r2).to eq(r1)
    end
  end
end

