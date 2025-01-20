require 'rails_helper'

describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:discount) }
    it { should validate_inclusion_of(:active).in_array([true, false]) }
    it { should validate_presence_of (:num_of_uses) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end

  describe 'class methods' do
    describe 'filter by active status' do
      it 'should filter a merchant\'s coupons by active status' do
        merchant = create(:merchant)
        coupon1 = Coupon.create(name: "New Years Discount", code: "NY2025", discount: 0.4, active: true, merchant_id: merchant.id, num_of_uses: 2);
        coupon2 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", discount: 0.25, active: true, merchant_id: merchant.id, num_of_uses: 1);
        coupon3 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", discount: 0.5, active: false, merchant_id: merchant.id, num_of_uses: 3);

        expect(merchant.coupons.filter_by_active_status("active")).to eq([coupon1, coupon2])
        expect(merchant.coupons.filter_by_active_status("inactive")).to eq([coupon3])
      end
    end

    describe 'apply coupon' do
      before(:each) do
        @customer = create(:customer)
        @merchant = create(:merchant)
        @coupon = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", discount: 0.25, active: true, merchant_id: @merchant.id, num_of_uses: 1);
        @invoice1 = create(:invoice, status: "packaged", merchant_id: @merchant.id, customer_id: @customer.id, coupon_id: null)
        @invoice2 = create(:invoice, status: "packaged", merchant_id: @merchant.id, customer_id: @customer.id, coupon_id: null)
      end
      it 'should apply coupon to an invoice and update coupon_id for invoice' do
        expect(@invoice1.coupon_id).to eq(null)

        @coupon.apply_coupon(@invoice1)
        expect(@invoice1.coupon_id).to eq(@coupon.id)
      end

      it 'should increase the num of uses for that coupon' do
        @coupon.apply_coupon(@invoice1)
        expect(@coupon.num_of_uses).to eq(2)

        @coupon.apply_coupon(@invoice2)
        expect(@coupon.num_of_uses).to eq(3)
      end
    end 
  end
end