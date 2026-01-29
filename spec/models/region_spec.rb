require 'rails_helper'

RSpec.describe Region, type: :model do

  it "exists" do
    Region.new
  end

  it "has a name" do
    region = Region.new
    expect(region).to respond_to(:name)
  end

  it "has a string representation that is its name" do
    name = 'Mt. Hood'
    region = Region.new(name: name)
    result = region.to_s
  end

  describe ".unspecified" do
    it "returns a region named 'Unspecified'" do
      region = Region.unspecified
      expect(region.name).to eq("Unspecified")
    end

    it "does not create duplicate 'Unspecified' regions" do
      r1 = Region.unspecified
      r2 = Region.unspecified
      expect(r1.id).to eq(r2.id)
    end
  end

end
