class RemoveLockVersionFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lock_version
  end
end
