require "rails_helper"

RSpec.describe UsersController, type: :controller do
  it "is a controller" do
    expect(described_class < ApplicationController).to be(true)
  end
end