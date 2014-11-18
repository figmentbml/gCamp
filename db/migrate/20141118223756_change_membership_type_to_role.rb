class ChangeMembershipTypeToRole < ActiveRecord::Migration
  def change
    rename_column :memberships, :type, :role
  end
end
