class ChangeQualificationsDefault < ActiveRecord::Migration
  def change
    change_column_default :users, :qualifications_count, 0
    change_column_default :users, :qualifications_total, 0
  end
end
