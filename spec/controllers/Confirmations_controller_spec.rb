require "rails_helper"

RSpec.describe Users::ConfirmationsController, type: :controller do
  it "is a Devise confirmations controller" do
    expect(described_class < Devise::ConfirmationsController).to be(true)
  end
end