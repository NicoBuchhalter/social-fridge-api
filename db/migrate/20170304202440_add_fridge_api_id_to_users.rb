class AddFridgeApiIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fridge_api_id, :integer
  end
end
