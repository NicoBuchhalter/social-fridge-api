class AddActivatedAtToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :activated_at, :datetime
  end
end
