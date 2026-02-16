require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do
  it "exists" do
    ResourceCategory.new
  end
  describe "factory" do
    it "builds a valid resouce category" do
      expect(build(:resource_category)).to be_a(ResourceCategory)
    end
  end

  describe "validation tests" do
    let (:test_category) { ResourceCategory.new(
      name: "test name"
    ) }

    it "must have a valid email" do  
      should validate_presence_of(:name).on(:create)    
    end

    it "email should length" do
      should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
    end
    it "email should be unique" do
      should validate_uniqueness_of(:name).case_insensitive.on(:create)
    end
  end

  describe "possession tests" do
    it "should have multiple tickets" do
      should have_many(:tickets)
    end
    it "should have and belong to multiple organizations" do
      should have_and_belong_to_many(:organizations)
    end
  end

  describe "scope tests" do
    let (:active_category) do
      category = ResourceCategory.new(
          name: "active category",
      )
      category.activate
      category
    end
    let (:inactive_category) do
      category = ResourceCategory.new(
        name: "inactive category",
      )
      category.deactivate
      category
    end
    it "scopes active categories" do
      expect(ResourceCategory.active).to include(active_category)
    end

    it "scopes inactive categories" do
      expect(ResourceCategory.inactive).to include(inactive_category)
    end
  end

  describe "unspecified method test" do
    let (:test_category) { ResourceCategory.unspecified }
    it "returns default status of submitted" do
      expect(test_category.name).to eq "Unspecified"
    end
  end

  describe "Resource category active status" do
    let (:test_category) { ResourceCategory.new }
    it "returns status of true" do
      test_category.activate
      expect(test_category.active).to be true
    end
    it "returns status of false" do
      test_category.deactivate
      expect(test_category.active).to be false
    end
  end

  describe " inactive? method tests" do
    it "returns true when not active" do
      category = ResourceCategory.new(
        name: "inactive category",
        active: false
      )
      expect(category.inactive?).to be true
    end
    it "returns false when active" do
      category = ResourceCategory.new(
          name: "inactive category",
          active: true
      )
      expect(category.inactive?).to be false
    end
  end

  describe "to_s test" do
    it "returns the name of the category" do
      category = ResourceCategory.new(
          name: "test category"
      )
      expect(category.to_s).to eq "test category"
    end
  end
end
