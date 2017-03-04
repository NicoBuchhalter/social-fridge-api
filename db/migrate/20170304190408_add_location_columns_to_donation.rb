class AddLocationColumnsToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :address, :string
    add_column :donations, :lat, :float
    add_column :donations, :lng, :float
  end
end
