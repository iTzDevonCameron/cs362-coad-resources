require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  it "is a Devise omniauth callbacks controller" do
    expect(described_class < Devise::OmniauthCallbacksController).to be(true)
  end
end