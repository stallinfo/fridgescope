class CreateAdministrators < ActiveRecord::Migration[6.1]
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :identify

      t.timestamps
    end
  end
end
