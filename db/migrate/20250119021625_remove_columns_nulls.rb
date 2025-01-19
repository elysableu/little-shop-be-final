class RemoveColumnsNulls < ActiveRecord::Migration[7.1]
  def change
    change_column_null :coupons, :name, true
    change_column_null :coupons, :code, true
    change_column_null :coupons, :discount, true
    change_column_null :coupons, :active, true
    change_column_null :coupons, :merchant_id,  true
    change_column_null :coupons, :num_of_uses, true
  end
end
