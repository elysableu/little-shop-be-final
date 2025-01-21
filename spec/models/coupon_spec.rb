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

  describe 'behaviors' do
    before(:each) do
      @customer = create(:customer)
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @coupon1 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", discount: 0.25, active: true, merchant_id: @merchant1.id, num_of_uses: 1)
      @coupon2 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", discount: 0.5, active: false, merchant_id: @merchant1.id, num_of_uses: 3)
      @coupon3 = Coupon.create(name: "New Years Discount", code: "NY2025", discount: 0.4, active: true, merchant_id: @merchant2.id, num_of_uses: 2)

      @invoice1 = Invoice.create(status: "packaged", merchant_id: @merchant1.id, customer_id: @customer.id, coupon_id: nil)
      @invoice2 = Invoice.create(status: "packaged", merchant_id: @merchant1.id, customer_id: @customer.id, coupon_id: nil)
    end

    describe 'filter by active status' do
      it 'should filter a merchant\'s coupons by active status' do
        active_results = @merchant1.coupons.filter_by_active_status("active")
        inactive_results = @merchant2.coupons.filter_by_active_status("inactive")
        expect(active_results[0][:id]).to eq(@coupon1.id)
        expect(inactive_results[0][:id]).to eq(@coupon3.id)
      end
    end

    describe 'apply coupon' do
      it 'should apply coupon to an invoice and update coupon_id for invoice' do
        expect(@invoice1.coupon_id).to eq(nil)

        @coupon1.apply_coupon(@invoice1)
        expect(@invoice1.coupon_id).to eq(@coupon1.id)
      end

      it 'should increase the num of uses for that coupon' do
        @coupon2.apply_coupon(@invoice1)
        expect(@coupon2.num_of_uses).to eq(4)

        @coupon2.apply_coupon(@invoice2)
        expect(@coupon2.num_of_uses).to eq(5)
      end

      it 'should throw an error if the coupon merchant_id is not the same as invoices merchant_id' do
        expect{ @coupon3.apply_coupon(@invoice1) }.to raise_error(ArgumentError, "Merchant IDs for both the coupon and invoice must match")
      end

      it 'should throw an error if the coupon is inactive' do
        expect{ @coupon2.apply_coupon(@invoice2) }.to raise_error(ArgumentError, "Coupon must be active to be applied to a coupon")
      end
    end 
  end
end