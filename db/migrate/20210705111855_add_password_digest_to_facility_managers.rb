class AddPasswordDigestToFacilityManagers < ActiveRecord::Migration[6.1]
  def change
    add_column :facility_managers, :password_digest, :string
  end
end
