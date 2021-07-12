class AddRememberDigestToServiceManagers < ActiveRecord::Migration[6.1]
  def change
    add_column :service_managers, :remember_digest, :string
  end
end
