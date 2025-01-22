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

  before_save :enforce_limit_active_coupons

  def self.filter_by_active_status(status) 
    if status == "active"
      filteredCoupons = self.where("coupons.active = ?", true).select("distinct coupons.*")
    else
      filteredCoupons = self.where("coupons.active = ?", false).select("distinct coupons.*")
    end

    return filteredCoupons
  end

  private

  def enforce_limit_active_coupons
    return unless merchant

    active_count = merchant.coupons.where(active: true).count
    
    if active? && (new_record? || active_changed?(from: false, to: true))
      if active_count >= 5
        raise ActiveRecord::RecordNotSaved.new(self), "Coupon could not be saved due to active coupon limit"
        throw(:abort)
      end
    end
  end
end