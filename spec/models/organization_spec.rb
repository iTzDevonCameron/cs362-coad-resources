require 'rails_helper'

RSpec.describe Organization, type: :model do
  it "exists" do
    expect(build(:organization)).to be_valid
  end

  describe "Responds to attributes" do
    let (:organization) { build(:organization) } 
    it "Should respond to" do
      expect(organization).to respond_to(:agreement_one)
      expect(organization).to respond_to(:agreement_two)
      expect(organization).to respond_to(:agreement_three)
      expect(organization).to respond_to(:agreement_four)
      expect(organization).to respond_to(:agreement_five)
      expect(organization).to respond_to(:agreement_six)
      expect(organization).to respond_to(:agreement_seven)
      expect(organization).to respond_to(:agreement_eight)
    end
  end

  describe "possession tests" do
    it "should have multiple users" do
      should have_many(:users)
    end
    it "should have multiple tickets" do
      should have_many(:tickets)
    end
    it "should have and belong to multiple resource categories" do
      should have_and_belong_to_many(:resource_categories)
    end
  end

  describe "validation tests" do
    subject { build(:organization) } 
    before { create(:organization) }

    it "must have a valid email" do  
      should validate_presence_of(:email).on(:create)    
    end

    it "email should length" do
      should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
    end
    it "email should be unique" do
      should validate_uniqueness_of(:email).case_insensitive.on(:create)
    end

    it "must have a valid name" do
      should validate_presence_of(:name)
    end

    it "should have a valid description" do
      should validate_length_of(:description)
    end
  end

  describe "Organization status" do
    let (:organization) { build(:organization) } 
    it "returns default status of submitted" do
      expect(organization.status).to eq "submitted"
    end
    it "returns status of approved" do
      organization.approve
      expect(organization.status).to eq "approved"
    end
    it "returns status of rejected" do
      organization.reject
      expect(organization.status).to eq "rejected"
    end
  end
  
  describe "Name is set" do
    it "returns the name of the organization" do
      expect(build(:organization).to_s).to eq "Test Org"
    end
  end
end