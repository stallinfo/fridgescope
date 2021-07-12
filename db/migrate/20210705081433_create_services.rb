class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :connection_phrase
      t.text :description
      t.integer :update_count
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
