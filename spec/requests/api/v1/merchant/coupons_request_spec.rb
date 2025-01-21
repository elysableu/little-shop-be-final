require "rails_helper"

describe "Coupon Endpoints", :type => :request do
  before(:each) do
    @merchant1 = create(:merchant)
    @coupon1 = Coupon.create(name: "New Years Discount", code: "NY2025", percent_discount: 0.4, active: true, merchant_id: @merchant1.id, num_of_uses: 2, dollar_discount: 0);
    @coupon2 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", percent_discount: 0.25, active: true, merchant_id: @merchant1.id, num_of_uses: 1, dollar_discount: 0);
    @coupon3 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", percent_discount: 0.5, active: false, merchant_id: @merchant1.id, num_of_uses: 3, dollar_discount: 0);
  end

  describe "GET merchants coupon by id" do
    it "should return a single coupon by ID" do
      name = "New Years Discount"
      code = "NY2025"
      percent_discount = 0.4
      active = true
      num_of_uses = 2
      dollar_discount = 0

      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data]).to include(:id, :type, :attributes)
      expect(json[:data][:id]).to eq("#{@coupon1.id}")
      expect(json[:data][:type]).to eq("coupon")
      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:attributes][:code]).to eq(code)
      expect(json[:data][:attributes][:percent_discount]).to eq(percent_discount)
      expect(json[:data][:attributes][:active]).to eq(active)
      expect(json[:data][:attributes][:num_of_uses]).to eq(num_of_uses)
      expect(json[:data][:attributes][:dollar_discount]).to eq(dollar_discount)
    end

    it "should return 404 and error message when coupon is not found" do
      test_id = 99999

      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{test_id}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to be_a Array
      expect(json[:errors].first).to eq("Couldn't find Coupon with 'id'=#{test_id}")
    end
  end

  describe "GET all merchants coupons" do
    it "should return all coupons for a given merchant" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:id]).to eq(@coupon1.id.to_s)
      expect(json[:data][1][:id]).to eq(@coupon2.id.to_s)
      expect(json[:data][2][:id]).to eq(@coupon3.id.to_s)
    end

    it "should return all coupons filtered by active status" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons?status=active"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:data].count).to eq(2)
      expect(json[:data][0][:id]).to eq(@coupon1.id.to_s)
      expect(json[:data][1][:id]).to eq(@coupon2.id.to_s)
    end

    it "should return a 404 and error meassge when merchant is not found" do
      test_id = 999999
      
      get "/api/v1/merchants/#{test_id}/coupons"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json[:message]).to eq("Your query could not be completed")
      expect(json[:errors]).to be_a Array
      expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=#{test_id}")
    end
  end

  describe "POST Create coupon" do
    it "should create a coupon for a merchant when all fields are provided" do
      name = "Winter Holiday Sale"
      code = "WINTER_HOL_2024"
      percent_discount = 0.6
      active = true
      merchant_id = @merchant1.id
      num_of_uses = 1
      dollar_discount = 0
      body = {
        name: name,
        code: code,
        percent_discount: percent_discount,
        active: active,
        merchant_id: merchant_id,
        num_of_uses: num_of_uses,
        dollar_discount: dollar_discount
      }

      post "/api/v1/merchants/#{@merchant1.id}/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)
      

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes][:name]).to eq(name)
      expect(json[:data][:attributes][:code]).to eq(code)
      expect(json[:data][:attributes][:percent_discount]).to eq(percent_discount)
      expect(json[:data][:attributes][:active]).to eq(active)
      expect(json[:data][:attributes][:merchant_id]).to eq(merchant_id)
      expect(json[:data][:attributes][:num_of_uses]).to eq(num_of_uses)
      expect(json[:data][:attributes][:dollar_discount]).to eq(dollar_discount)
    end

    it "should display an error message if not all fields are present" do
      body = {
        name: "name",
        code: "code",
        merchant_id: @merchant1.id,
        dollar_discount: 0
      }

      post "/api/v1/merchants/#{@merchant1.id}/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:errors].first).to eq("Validation failed: Percent discount can't be blank, Active is not included in the list, Num of uses can't be blank")
    end

    it "should ignore unnecessary fields" do
      body = {
        name: "name",
        code: "code2",
        percent_discount: 0.5,
        active: true,
        extra_field: "bad stuff",
        merchant_id: @merchant1.id,
        num_of_uses: 2,
        dollar_discount: 0
      }
      
      post "/api/v1/merchants/#{@merchant1.id}/coupons", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:data][:attributes]).to_not include(:extra_field)
      expect(json[:data][:attributes]).to include(:name, :code, :percent_discount, :active, :merchant_id, :num_of_uses, :dollar_discount)
    end
  end

  describe "Update coupon status" do
    describe "Active to Inactive" do
      it "should update active status from true to false" do
        active_status = false
        body = {
          active: active_status
        }

        patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}", params: body, as: :json
        json = JSON.parse(response.body, symbolize_names: :true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:attributes][:active]).to eq(active_status)
      end
    end
  
    describe "Inactive to Active" do
      it "should udpate active status from false to true" do
        active_status = true
        body = {
          active: active_status
        }

        patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon3.id}", params: body, as: :json
        json = JSON.parse(response.body, symbolize_names: :true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:attributes][:active]).to eq(active_status)
      end

      it "should return an error if the merchant already has 5 active coupons" do
        coupon4 = Coupon.create(name: "Predisdents Weekend Sale", code: "PDSale", percent_discount: 0.25, active: true, merchant_id: @merchant1.id, num_of_uses: 1, dollar_discount: 0)
        coupon5 = Coupon.create(name: "Easter Sale", code: "BigBunny25", percent_discount: 0.3, active: true, merchant_id: @merchant1.id, num_of_uses: 3, dollar_discount: 0)
        coupon6 = Coupon.create(name: "Spirit Halloween Close Out", code: "BOO2024", percent_discount: 0.75, active: true, merchant_id: @merchant1.id, num_of_uses: 2, dollar_discount: 0)

        active_status = true
        body = {
          active: active_status
        }
        patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon3.id}", params: body, as: :json
        json = JSON.parse(response.body, symbolize_names: :true)
        
        expect(json[:errors].first).to eq("This merchant already has 5 active coupons, no more can be activated")
      end
    end

    it "should return 404 when id provided is not valid" do
      test_id = 99999
      active_status = false
      body = {
        active: active_status
      }

      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{test_id}", params: body, as: :json
      json = JSON.parse(response.body, symbolize_names: :true)

      expect(response).to have_http_status(:not_found)
      expect(json[:errors].first).to eq("Couldn't find Coupon with 'id'=#{test_id}")
    end
  end
end