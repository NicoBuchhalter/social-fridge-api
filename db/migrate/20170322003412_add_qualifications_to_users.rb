class AddQualificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :qualifications_count, :integer
    add_column :users, :qualifications_total, :integer
    add_column :users, :lock_version, :integer
  end
end
