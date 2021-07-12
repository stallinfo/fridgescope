class CreateFacilityManagers < ActiveRecord::Migration[6.1]
  def change
    create_table :facility_managers do |t|
      t.references :facility, null: false, foreign_key: true
      t.string :identify
      t.string :name
      t.string :email
      t.integer :update_count
      t.string :created_by
      t.string :created_api_caller
      t.string :updated_by
      t.string :updated_api_caller

      t.timestamps
    end
  end
end
