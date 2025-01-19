class AddColumnToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :num_of_uses, :integer, null: false
  end
end
