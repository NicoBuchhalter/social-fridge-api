class AddDeviceTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device_tokens, :json, default: {}
  end
end
