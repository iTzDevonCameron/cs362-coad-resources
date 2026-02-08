require 'rails_helper'

RSpec.describe User, type: :model do
  describe "factory" do
    it "builds a valid user" do
      expect(build(:user)).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:organization).optional }
  end

  describe "validations" do
    it { should validate_presence_of(:email).on(:create) }
    it { should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_uniqueness_of(:email).case_insensitive.on(:create) }

    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(7).is_at_most(255).on(:create) }
  end

  describe "Email validations" do
    let(:good_user) { build(:user, email: "goodemail@example.com") }
    let(:bad_user)  { build(:user, email: "bad email") }

    it "allows a valid email" do
      expect(good_user).to be_valid
    end

    it "rejects an invalid email" do
      expect(bad_user).not_to be_valid
    end
  end

  describe "#to_s" do
    it "returns the user's email" do
      user = build(:user, email: "test@example.com")
      expect(user.to_s).to eq("test@example.com")
    end
  end

  describe "default role" do
    it "defaults role to organization" do
      user = build(:user)
      expect(user.role).to eq("organization")
    end
  end
end
