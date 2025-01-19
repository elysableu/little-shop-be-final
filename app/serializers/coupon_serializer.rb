class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :discount, :active, :merchant_id, :num_of_uses
end