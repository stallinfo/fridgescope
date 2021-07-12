class AddIndexToFacilityManagersEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :facility_managers, :email, unique: false
  end
end
