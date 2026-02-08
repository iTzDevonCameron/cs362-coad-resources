FactoryBot.define do
  sequence(:region_name) { |n| "Region #{n}" }
  factory :region do
    name { generate(:region_name) }
  end
end
