class AddTypeAndLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    add_column :users, :lat, :float
    add_column :users, :lng, :float
    add_column :users, :address, :string
  end
end
