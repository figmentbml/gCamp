class AddColumnToMembershipForAdmins < ActiveRecord::Migration
  def change
    add_column :memberships, :admin, :boolean, :default => false
  end
end
