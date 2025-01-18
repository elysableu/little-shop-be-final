class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.float :discount, null: false
      t.boolean :active, null: false, default: true
      t.integer :num_of_uses, null: false

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end
