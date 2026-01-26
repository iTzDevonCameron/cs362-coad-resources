require 'rails_helper'

RSpec.describe Organization, type: :model do
    it "exists" do
        Organization.new
    end

    let (:organization) { Organization.new }


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
        let (:test_organization) { Organization.new(
            email: "test@example.com",
            name: "test name",
            phone: "9035768145",
            status: "active",
            primary_name: "primary",
            secondary_name: "secondary",
            secondary_phone: "5418675309",
            description: "description"
        ) }
        
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
        let (:test_organization) { Organization.new }

        it "returns default status of submitted" do
            expect(test_organization.status).to eq "submitted"
        end

        it "returns status of approved" do
            test_organization.approve
            expect(test_organization.status).to eq "approved"
        end

        it "returns status of rejected" do
            test_organization.reject
            expect(test_organization.status).to eq "rejected"
        end
    end

    describe "Name is set" do
        let (:test_organization) {Organization.new(name: "test_org")}
        it "Prints the name of the organization" do
            expect(test_organization.to_s).to eq "test_org"
        end
    end



end
