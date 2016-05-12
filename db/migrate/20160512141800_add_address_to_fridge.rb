class AddAddressToFridge < ActiveRecord::Migration
  def change
    add_column :fridges, :address, :string
  end
end
