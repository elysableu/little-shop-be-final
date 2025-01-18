require "rails_helper"

describe "Coupon Endpoints", :type => :request do
  before(:each) do
    @merchant1 = create(:merchant)
    @coupon1 = Coupon.create!(name: "New Years Discount", code: "NY2025", discount: 0.4, active: true);
    @coupon2 = Coupon.create!(name: "Valentines Gift Sale", code: "FEB14LOVE", discount: 0.25, active: true);
    @coupon3 = Coupon.create!(name: "Spring Celebration BOGO", code: "SPRBOGO25", discount: 0.5, active: false);
  end

  describe "GET all merchants coupons" do

  end

  describe "GET coupon by id" do

  end

  describe "Create coupon" do

  end

  describe "Update coupon status" do
    describe "Active to Inactive" do

    end

    describe "Inactive to Active" do

    end
  end

  # let(:coupon) {Coupon.create!(name: , code: , discount: , active: , num_of_uses: , merchant_id:)}
end