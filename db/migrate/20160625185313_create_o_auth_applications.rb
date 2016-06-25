class CreateOAuthApplications < ActiveRecord::Migration
  def change
    create_table :o_auth_applications do |t|
      t.string :name
      t.string :app_id
      t.boolean :enabled, default: false

      t.timestamps null: false
    end
  end
end
