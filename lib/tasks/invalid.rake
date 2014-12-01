namespace :invalid do
  desc "Find invalid data"
  task list: :environment do
    p Membership.where(role: "true")
    p Membership.where.not(user_id: User.all)
    p User.all
    p User.where(first_name: nil)
    p User.where(first_name: nil)
    p Comment.where.not(task_id: Task.all)
    p Comment.where.not(user_id: User.all)
  end

  desc "Deletes invalid data"
  task delete: :environment do
    Membership.where(role: "true").delete_all
    Membership.where.not(user_id: User.all).delete_all
    User.where(first_name: nil).delete_all
    User.where(last_name: nil).delete_all
    Task.where(project_id: nil).delete_all
    Comment.where.not(task_id: Task.all).delete_all
  end
end
