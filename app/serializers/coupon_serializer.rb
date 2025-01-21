class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :percent_discount, :dollar_discount, :active, :merchant_id
end