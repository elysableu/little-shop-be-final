class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :merchant_id, presence: true
  validates :num_of_uses, presence: true
  belongs_to :merchant
  has_many :invoices

  def self.filter_by_active_status(status) 
    if status == "active"
      filteredCoupons = self.where("coupons.active = ?", true).select("distinct coupons.*")
    else
      filteredCoupons = self.where("coupons.active = ?", false).select("distinct coupons.*")
    end

    return filteredCoupons
  end
end