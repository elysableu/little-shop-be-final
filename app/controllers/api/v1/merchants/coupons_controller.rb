class Api::V1::Merchants::CouponsController < ApplicationController
  
  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def index
    merchant = Merchant.find(params[:merchant_id])
    if params[:status].present?
      coupons = merchant.coupons.filter_by_active_status(params[:status])
    else
      coupons = merchant.coupons
    end

    render json: CouponSerializer.new(coupons)
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
