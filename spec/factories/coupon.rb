FactoryBot.define do
  factory :coupon do
    name { Faker::Commerce.product_name + " Sale" }
    code { Faker::Commerce.promotion_code }
    percent_discount { Faker::Number.between(from: 0.10, to: 0.75).to_f.round(2) }
    active { [true, false].sample}
    merchant_id {nil}
    num_of_uses { Faker::Number.between(from: 0, to: 5) }
    dollar_discount { 0.0 }
  end
end