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
end