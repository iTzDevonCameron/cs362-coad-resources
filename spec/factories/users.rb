FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "org#{n}@example.com" }
    password { "Fake_password" }


    before(:create) { |user| user.skip_confirmation!}

    trait :organization_approved do
      role { :organization }
      organization_id { create(:organization).id }
    end

    trait :admin do
      role { :admin }
    end
  end
end