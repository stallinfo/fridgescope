class AddIndexToFacilityManagersEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :facility_managers, :identify, unique: true
  end
end
