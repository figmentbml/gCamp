class Membership < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  validates :user_id, presence: :true, uniqueness: :true
  validates :role, presence: :true

end
