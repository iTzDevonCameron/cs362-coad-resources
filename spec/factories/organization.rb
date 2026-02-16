FactoryBot.define do
  factory :organization do
    sequence(:email) { |n| "org#{n}@example.com" }
    name { "Test Org" }
    phone { "9035768145" }
    status { "submitted" }
    primary_name { "Primary" }
    secondary_name { "Secondary" }
    secondary_phone { "5418675309" }
    description { "Test description" }

    trait :approved do
      status { "approved" }
    end

    trait :rejected do
      status { "rejected" }
    end
  end
end