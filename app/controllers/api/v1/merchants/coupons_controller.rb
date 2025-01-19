class Api::V1::Merchants::CouponsController < ApplicationController
  
  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: CouponSerializer.new(merchant.coupons)
  end

end
