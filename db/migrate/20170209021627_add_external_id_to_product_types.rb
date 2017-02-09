class AddExternalIdToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :external_id, :integer
    add_index :product_types, :external_id, unique: true
  end
end
