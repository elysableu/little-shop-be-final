class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :percent_discount, :dollar_discount, :active, :merchant_id, :num_of_uses
end