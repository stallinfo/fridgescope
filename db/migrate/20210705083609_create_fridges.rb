class CreateFridges < ActiveRecord::Migration[6.1]
  def change
    create_table :fridges do |t|
      t.references :facility, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :initial_storage_rate
      t.integer :update_count
      t.string :created_by
      t.string :created_api_caller
      t.string :updated_by
      t.string :updated_api_caller

      t.timestamps
    end
  end
end
