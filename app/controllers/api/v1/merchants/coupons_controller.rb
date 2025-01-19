class Api::V1::Merchants::CouponsController < ApplicationController
  
  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: CouponSerializer.new(merchant.coupons)
  end

  def create
    coupon = Coupon.create!(coupon_params) 
    render json: CouponSerializer.new(coupon), status: :created
  end

  def update
    coupon = Coupon.find(params[:id])

    if coupon[:active]
      coupon.update(active: false)
      coupon.save

      render json: CouponSerializer.new(coupon), status: :ok
    else
      coupon.update(active: true)
      coupon.save

      render json: CouponSerializer.new(coupon), status: :ok
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :discount, :active, :merchant_id, :num_of_uses)
  end
end
