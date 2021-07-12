class AddRememberDigestToFacilityManagers < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_managers, :remember_digest, :string
  end
end
