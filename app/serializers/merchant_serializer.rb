class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name, :coupons_count, :invoice_coupon_count

  attribute :item_count, if: Proc.new { |merchant, params|
    params && params[:count] == true
  } do |merchant|
    merchant.item_count
  end

  attribute :coupon_count, if: Proc.new { |merchant, params| 
    params && params[:coupon_counts] == true
  } do |merchant|
    merchant.coupon_count
  end

  attribute :invoice_coupon_count, if: Proc.new { |merchant, params| 
    params && params[:coupon_counts] == true
  } do |merchant|
    merchant.invoice_coupon_count
  end
end
