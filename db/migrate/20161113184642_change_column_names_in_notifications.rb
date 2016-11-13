class ChangeColumnNamesInNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :from_id_id, :from_id
    rename_column :notifications, :to_id_id, :to_id
  end
end
