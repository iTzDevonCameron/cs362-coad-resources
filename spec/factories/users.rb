FactoryBot.define do
  sequence(:email) { |n| "fakeuser#{n}@fakedomain#{n}.com" }
  factory :user do
    email
    password { "password123" }
    password_confirmation { "password123" }
  end
end
