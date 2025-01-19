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
    it 'should filter a merchant\'s coupons by active status' do
      merchant = create(:merchant)
      coupon1 = Coupon.create(name: "New Years Discount", code: "NY2025", discount: 0.4, active: true, merchant_id: merchant.id, num_of_uses: 2);
      coupon2 = Coupon.create(name: "Valentines Gift Sale", code: "FEB14LOVE", discount: 0.25, active: true, merchant_id: merchant.id, num_of_uses: 1);
      coupon3 = Coupon.create(name: "Spring Celebration BOGO", code: "SPRBOGO25", discount: 0.5, active: false, merchant_id: merchant.id, num_of_uses: 3);

      expect(merchant.coupons.filtered_by_active_status("active")).to eq([coupon1, coupon2])
      expect(merchant.coupons.filtered_by_active_status("inactive")).to eq([coupon3])
    end
  end
end