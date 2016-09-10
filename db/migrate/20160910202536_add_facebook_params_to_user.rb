class AddFacebookParamsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :fb_id, :string
    add_column :users, :fb_access_token, :string
    add_column :users, :username, :string
  end
end
