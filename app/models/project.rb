class Project < ActiveRecord::Base

  has_many :tasks, dependent: :destroy
  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  validates :name, presence: true

end
