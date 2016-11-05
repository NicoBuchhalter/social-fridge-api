class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :from_id, index: true
      t.references :to_id, index: true
      t.integer :n_type
      t.integer :number
      t.datetime :specific_date

      t.timestamps null: false
    end
  end
end
