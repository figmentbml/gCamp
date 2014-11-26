namespace :memberships do
  desc "Find invalid memberships and comments"
  task list: :environment do
    p Membership.where(role: "true")
    p Membership.where.not(user_id: User.all)
    p User.all
    p User.where(first_name: nil)
    p User.where(first_name: nil)
  end

  desc "Deletes invalid memberships, users, and tasks"
  task delete: :environment do
    Membership.where(role: "true").delete_all
    Membership.where.not(user_id: User.all).delete_all
    User.where(first_name: nil).delete_all
    User.where(last_name: nil).delete_all
    Task.where(project_id: nil).delete_all
  end
end
