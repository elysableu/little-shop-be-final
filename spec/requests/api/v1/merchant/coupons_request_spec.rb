require "rails_helper"

describe "Coupon Endpoints", :type => :request do
  before(:each) do
    @merchant1 = create(:merchant)
    @coupon1 = Coupon.create!(name: "New Years Discount", code: "NY2025", discount: 0.4, active: true, merchant_id: @merchant1.id);
    @coupon2 = Coupon.create!(name: "Valentines Gift Sale", code: "FEB14LOVE", discount: 0.25, active: true, merchant_id: @merchant1.id);
    @coupon3 = Coupon.create!(name: "Spring Celebration BOGO", code: "SPRBOGO25", discount: 0.5, active: false, merchant_id: @merchant1.id);
  end

  describe "GET merchants coupon by id" do

  end

  describe "GET all merchants coupons" do
    it "should return all items for a given merchant" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:id]).to eq(@coupon1.id.to_s)
      expect(json[:data][1][:id]).to eq(@coupon2.id.to_s)
      expect(json[:data][2][:id]).to eq(@coupon3.id.to_s)
    end

    it "should return a 404 and error meassge when merchant is not found" do
      test_id = 999999
      
      get "/api/v1/merchants/#{test_id}/items"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to be_a Array
      expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=#{test_id}")
    end
  end

  describe "Create coupon" do

  end

  describe "Update coupon status" do
    describe "Active to Inactive" do

    end

    describe "Inactive to Active" do

    end
  end
end