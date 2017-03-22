class AddQualificationsToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :volunteer_qualification, :integer
    add_column :donations, :donator_qualification, :integer
  end
end
