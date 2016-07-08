class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|

      t.timestamps null: false
      t.datetime  :pickup_time_from
      t.datetime  :pickup_time_to
      t.string :description
      t.references :donator, references: :users, null: false, index: true
      t.references :volunteer, references: :users, index:true
      t.references :fridge, references: :users, index:true
    end

    add_foreign_key :donations, :users, column: :donator_id
    add_foreign_key :donations, :users, column: :volunteer_id
    add_foreign_key :donations, :users, column: :fridge_id

  end
end
