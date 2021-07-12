class CreateFacilities < ActiveRecord::Migration[6.1]
  def change
    create_table :facilities do |t|
      t.references :service, null: false, foreign_key: true
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.integer :update_count
      t.string :created_by
      t.string :created_api_caller
      t.string :updated_by
      t.string :updated_api_caller

      t.timestamps
    end
  end
end
