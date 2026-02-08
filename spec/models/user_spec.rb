require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, :name => "Some other name") }
  before do
    @user1 = build(:user, :name => "User 1")
    @user2 = build(:user, :name => "User 2")
  end
  it "exists" do
    expect(@user1).to be_a(:user)
  end
  it "Belongs to organization" do
    should belong_to(:organization).optional
  end

  describe "validation tests" do
    let (:test_user) { @user1 }
    it "must have a valid email" do  
      should validate_presence_of(:email).on(:create)    
    end
    it "email should length" do
      should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
    end
    it "email should be unique" do
      should validate_uniqueness_of(:email).case_insensitive.on(:create)
    end
    it "must have a valid password" do  
      should validate_presence_of(:password).on(:create)    
    end
    it "password should be correct length" do
      should validate_length_of(:password).is_at_least(7).is_at_most(255).on(:create)
    end
  end

  describe "Email validations" do
    let (:good_user) { User.new(
      email: "goodemail@example.com",
      password: "testpassword"
    ) }
    let (:bad_user) { User.new(
      email: "bad email",
      password: "testpassword"
    ) }
    it "allows a valid email" do
      expect(good_user).to be_valid
    end
    it "rejects an invalid email" do
      expect(bad_user).not_to be_valid
    end
  end

  describe "to_s test" do
    it "returns the name of the category" do
      user = User.new(
          email: "test@example.com"
      )
      expect(user.to_s).to eq "test@example.com"
    end
  end

  describe "default role method test" do
    let (:test_user) { User.new }
    it "sets the default role to organization" do
      expect(test_user.role).to eq "organization"
    end
  end
end