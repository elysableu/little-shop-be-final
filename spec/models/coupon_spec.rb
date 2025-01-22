require 'rails_helper'

describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:percent_discount) }
    it { should validate_inclusion_of(:active).in_array([true, false]) }
    it { should validate_presence_of(:num_of_uses) }
    it { should validate_presence_of(:dollar_discount)}
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end

  describe 'behaviors' do
    before(:each) do
      @customer = create(:customer)
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @coupon1 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", percent_discount: 0.25, active: true, merchant_id: @merchant1.id, num_of_uses: 1, dollar_discount: 0)
      @coupon2 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", percent_discount: 0.5, active: false, merchant_id: @merchant1.id, num_of_uses: 3, dollar_discount: 0)
      @coupon3 = Coupon.create(name: "New Years Discount", code: "NY2025", percent_discount: 0.4, active: true, merchant_id: @merchant2.id, num_of_uses: 2, dollar_discount: 0)
      @coupon4 = Coupon.create(name: "Predisdents Weekend Sale", code: "PDSale", percent_discount: 0.25, active: false, merchant_id: @merchant2.id, num_of_uses: 1, dollar_discount: 0)


      @invoice1 = Invoice.create(status: "packaged", merchant_id: @merchant1.id, customer_id: @customer.id, coupon_id: nil)
      @invoice2 = Invoice.create(status: "packaged", merchant_id: @merchant1.id, customer_id: @customer.id, coupon_id: nil)
    end

    describe 'filter by active status' do
      it 'should filter a merchant\'s coupons by active status' do
        active_results = @merchant1.coupons.filter_by_active_status("active")
        inactive_results = @merchant2.coupons.filter_by_active_status("inactive")
        expect(active_results[0][:id]).to eq(@coupon1.id)
        expect(inactive_results[0][:id]).to eq(@coupon4.id)
      end
    end
  end
end