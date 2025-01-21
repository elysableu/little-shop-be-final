class AddDollarDiscountToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :dollar_discount, :float
  end
end
