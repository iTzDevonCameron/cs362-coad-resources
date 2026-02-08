FactoryBot.define do
  factory :region do
    name { "Region #{Faker::Address.unique.state}" }
  end
end