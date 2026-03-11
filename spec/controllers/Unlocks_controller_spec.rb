require "rails_helper"

RSpec.describe Users::UnlocksController, type: :controller do
  it "is a Devise unlocks controller" do
    expect(described_class < Devise::UnlocksController).to be(true)
  end
end