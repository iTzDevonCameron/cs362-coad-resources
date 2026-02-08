FactoryBot.define do
  factory :user do
    name { "User #{Faker::Address.unique.state}" }
  end
end