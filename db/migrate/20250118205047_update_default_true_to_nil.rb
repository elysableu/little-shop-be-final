class UpdateDefaultTrueToNil < ActiveRecord::Migration[7.1]
  def change
    change_column_default :coupons, :active, from: true, to: nil
  end
end
