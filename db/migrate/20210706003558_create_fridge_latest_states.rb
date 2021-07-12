class CreateFridgeLatestStates < ActiveRecord::Migration[6.1]
  def change
    create_table :fridge_latest_states do |t|
      t.references :fridge, null: false, foreign_key: true
      t.date :posted_at
      t.decimal :current_storage_rate
      t.integer :update_count
      t.string :created_by
      t.string :created_api_caller
      t.string :updated_by
      t.string :updated_api_caller

      t.timestamps
    end
  end
end
