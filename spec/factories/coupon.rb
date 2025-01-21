FactoryBot.define do
  factory :coupon do
    name { Faker::Name.first_name }
    code { Faker::Name.last_name }
    percent_discount { Faker::Name.last_name }
  end
end