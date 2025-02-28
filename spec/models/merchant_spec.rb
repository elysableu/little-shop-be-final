require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name)}
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "class methods" do
    it "should sort merchants by created_at" do
      merchant1 = create(:merchant, created_at: 1.day.ago)
      merchant2 = create(:merchant, created_at: 4.days.ago)
      merchant3 = create(:merchant, created_at: 2.days.ago)

      expect(Merchant.sorted_by_creation).to eq([merchant1, merchant3, merchant2])
    end

    it "should filter merchants by status of invoices" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      customer = create(:customer)
      create(:invoice, status: "returned", merchant_id: merchant1.id, customer_id: customer.id)
      create_list(:invoice, 5, merchant_id: merchant1.id, customer_id: customer.id)
      create_list(:invoice, 5, merchant_id: merchant2.id, customer_id: customer.id)
      create(:invoice, status: "packaged", merchant_id: merchant2.id, customer_id: customer.id)

      expect(Merchant.filter_by_status("returned")).to eq([merchant1])
      expect(Merchant.filter_by_status("packaged")).to eq([merchant2])
      expect(Merchant.filter_by_status("shipped")).to match_array([merchant1, merchant2])
    end

    it "should retrieve merchant when searching by name" do
      merchant1 = Merchant.create!(name: "Turing")
      merchant2 = Merchant.create!(name: "ring world")
      merchant3 = Merchant.create!(name: "Vera Wang")

      expect(Merchant.find_one_merchant_by_name("ring")).to eq(merchant2)
      expect(Merchant.find_all_by_name("ring")).to eq([merchant1, merchant2])
    end
  end

  describe "instance methods" do
    it "#item_count should return the count of items for a merchant" do
      merchant = Merchant.create!(name: "My merchant")
      merchant2 = Merchant.create!(name: "My other merchant")

      # These FactoryBot methods create lots of test data quickly with random attributes
      # The line below is the equivalent of running `merchant.items.create!` 8 times
      # In your new tests, you do not need to use FactoryBot unless you'd like to explore it
      create_list(:item, 8, merchant_id: merchant.id)
      create_list(:item, 4, merchant_id: merchant2.id)

      expect(merchant.item_count).to eq(8)
      expect(merchant2.item_count).to eq(4)
    end

    it "#coupon_count should return the total count of coupons for a merchant" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      coupon1 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", percent_discount: 0.25, active: true, merchant_id: merchant1.id, num_of_uses: 1, dollar_discount: 0)
      coupon2 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", percent_discount: 0.5, active: false, merchant_id: merchant1.id, num_of_uses: 3, dollar_discount: 0)
      coupon3 = Coupon.create(name: "New Years Discount", code: "NY2025", percent_discount: 0.4, active: false, merchant_id: merchant2.id, num_of_uses: 2, dollar_discount: 0)
  
      expect(merchant1.coupon_count).to eq(2)
      expect(merchant2.coupon_count).to eq(1)
    end

    it "#invoice_coupon_count should return the total count of invoices with applied coupons" do
      customer1 = create(:customer)
      customer2 = create(:customer)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      coupon1 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", percent_discount: 0.25, active: true, merchant_id: merchant1.id, num_of_uses: 1, dollar_discount: 0)
      coupon2 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", percent_discount: 0.5, active: true, merchant_id: merchant1.id, num_of_uses: 3, dollar_discount: 0)
      coupon3 = Coupon.create(name: "New Years Discount", code: "NY2025", percent_discount: 0.4, active: true, merchant_id: merchant2.id, num_of_uses: 2, dollar_discount: 0)
      
      invoice1 = Invoice.create(status: "packaged", merchant_id: merchant1.id, customer_id: customer1.id, coupon_id: coupon1.id)
      invoice2 = Invoice.create(status: "packaged", merchant_id: merchant1.id, customer_id: customer1.id, coupon_id: coupon2.id)
      invoice3 = Invoice.create(status: "packaged", merchant_id: merchant2.id, customer_id: customer2.id, coupon_id: coupon3.id)

      expect(merchant1.invoice_coupon_count).to eq(2)
      expect(merchant2.invoice_coupon_count).to eq(1)
    end

    it "#distinct_customers should return all customers for a merchant" do
      merchant1 = create(:merchant)
      customer1 = create(:customer)
      customer2 = create(:customer)
      customer3 = create(:customer)

      merchant2 = create(:merchant)

      create_list(:invoice, 3, merchant_id: merchant1.id, customer_id: customer1.id)
      create_list(:invoice, 2, merchant_id: merchant1.id, customer_id: customer2.id)

      create_list(:invoice, 2, merchant_id: merchant2.id, customer_id: customer3.id)

      expect(merchant1.distinct_customers).to match_array([customer1, customer2])
      expect(merchant2.distinct_customers).to eq([customer3])
    end

    it "#invoices_filtered_by_status should return all invoices for a customer that match the given status" do
      merchant = create(:merchant)
      other_merchant = create(:merchant)
      customer = create(:customer)
      inv_1_shipped = Invoice.create!(status: "shipped", merchant: merchant, customer: customer)
      inv_2_shipped = Invoice.create!(status: "shipped", merchant: merchant, customer: customer)
      inv_3_packaged = Invoice.create!(status: "packaged", merchant: merchant, customer: customer)
      inv_4_packaged = Invoice.create!(status: "packaged", merchant: other_merchant, customer: customer)
      inv_5_returned = Invoice.create!(status: "returned", merchant: merchant, customer: customer)

      expect(merchant.invoices_filtered_by_status("shipped")).to match_array([inv_1_shipped, inv_2_shipped])
      expect(merchant.invoices_filtered_by_status("packaged")).to eq([inv_3_packaged])
      expect(merchant.invoices_filtered_by_status("returned")).to eq([inv_5_returned])
      expect(other_merchant.invoices_filtered_by_status("packaged")).to eq([inv_4_packaged])
    end
  end
end
