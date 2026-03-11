require "rails_helper"

RSpec.describe Users::PasswordsController, type: :controller do
  it "is a Devise passwords controller" do
    expect(described_class < Devise::PasswordsController).to be(true)
  end
end