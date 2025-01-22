class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :percent_discount, :dollar_discount, :active, :num_of_uses, :merchant_id
end