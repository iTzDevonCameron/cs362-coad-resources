FactoryBot.define do
  factory :resource_category do
    sequence(:name) { |n| "Category #{n}" }
    active { true }

    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end

    trait :unspecified do
      name { "Unspecified" }
    end

    trait :with_tickets do
      after(:create) do |category|
        create_list(:ticket, 3, resource_category: category)
      end
    end

    trait :with_organizations do
      after(:create) do |category|
        category.organizations << create_list(:organization, 2)
      end
    end
  end
end