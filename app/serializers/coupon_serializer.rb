class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :discount, :active, :num_of_uses
end