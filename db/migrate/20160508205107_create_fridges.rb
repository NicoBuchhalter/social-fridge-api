class CreateFridges < ActiveRecord::Migration
  def change
    create_table :fridges do |t|
      t.float :lat, null: false
      t.float :lng, null: false

      t.timestamps null: false
    end
  end
end
