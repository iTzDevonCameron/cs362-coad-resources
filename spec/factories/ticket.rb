FactoryBot.define do
  factory :ticket do
    sequence(:name) { |n| "Ticket #{n}" }
    description { "Test description" }
    phone { "+1-555-555-5555" }
    closed { false }

    association :region

    # organization is optional, so no default association
    trait :with_organization do
      association :organization
    end

    trait :closed do
      closed { true }
    end
  end
end