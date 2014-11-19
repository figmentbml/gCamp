class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  validate :user_id, presence: :true
  validate :role, presence: :true

end
