class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  validates :user_id, presence: :true, uniqueness: {scope: :project_id,
    message: "should only have one membership per project" }
  validates :role, presence: :true

  before_destroy :cannot_delete_last_owner
  before_update :cannot_update_last_owner

  def owners
    project.memberships.where(role: 'owner')
  end

  def members
    project.memberships.where(role: 'member')
  end

  def cannot_delete_last_owner
    if owners.count == 1 && role == 'owner'
      return false
    end
  end

  def cannot_update_last_owner
    if owners.count > 1
      return true
    elsif owners.count == 1 && role == 'member'
      return false
    end
  end

end
