class AddPasswordDigestToServiceManagers < ActiveRecord::Migration[6.1]
  def change
    add_column :service_managers, :password_digest, :string
  end
end
