class DropTableFridges < ActiveRecord::Migration
  def change
  	drop_table :fridges
  end
end
