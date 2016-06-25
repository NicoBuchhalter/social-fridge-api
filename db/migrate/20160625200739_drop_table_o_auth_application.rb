class DropTableOAuthApplication < ActiveRecord::Migration
  def change
  	drop_table :o_auth_applications
  end
end
