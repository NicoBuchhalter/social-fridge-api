class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :donation
      t.belongs_to :product_type
      t.float :quantity
      t.date :expiration_date

      t.timestamps null: false
    end
  end
end
