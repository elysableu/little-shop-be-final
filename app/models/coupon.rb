class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :percent_discount, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :merchant_id, presence: true
  validates :num_of_uses, presence: true
  validates :dollar_discount, presence: true
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

  def apply_coupon(invoice) 
    if merchant_id != invoice.merchant_id
      raise ArgumentError, "Merchant IDs for both the coupon and invoice must match"
    end

    invoice.update(coupon_id: id)

    self.num_of_uses ||= 0
    self.num_of_uses += 1
    save!
  end
end