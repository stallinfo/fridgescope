class CreateServiceManagers < ActiveRecord::Migration[6.1]
  def change
    create_table :service_managers do |t|
      t.references :service, null: false, foreign_key: true
      t.string :name
      t.string :identify
      t.integer :update_count
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
