class RemoveColumnFromCoupons < ActiveRecord::Migration[7.1]
  def change
    remove_column :coupons, :num_of_uses, :interger
  end
end
