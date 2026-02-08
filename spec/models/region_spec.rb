require 'rails_helper'

RSpec.describe Region, type: :model do
  
  let(:region) { create(:region, :name => "Some other name") }

  before do
    @region1 = build(:region, :name => "Region 1")
    @region2 = build(:region, :name => "Region 2")
  end

  it "exists" do
    expect(@region1).to be_a(Region)
  end

  it "has a name" do
    region = Region.new
    expect(region).to respond_to(:name)
  end

  it "has a string representation that is its name" do
    expect(region.name).to eq("Some other name")
  end

  it "can find or create by name" do
    result = Region.unspecified
    expect(result).to be_a(Region)
  end
end
