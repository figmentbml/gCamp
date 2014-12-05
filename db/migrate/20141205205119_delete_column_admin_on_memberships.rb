class DeleteColumnAdminOnMemberships < ActiveRecord::Migration
  def change
    remove_column :memberships, :admin
  end
end
