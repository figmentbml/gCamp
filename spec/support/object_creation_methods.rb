def create_user(overrides = {})
  User.create!(
    {
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      admin: false
    }.merge(overrides)
  )
end

def create_membership(project, user, role = "owner", overrides = {})
  Membership.create!({
    user_id: user.id,
    project_id: project.id,
    role: role
  }.merge(overrides))
end

def create_project(overrides = {})
  Project.create!({
    name: "Singing"
  }.merge(overrides))
end

def create_task(project, overrides ={})
  Task.create!({
    description: "apple",
    complete: false,
    due_date: Date.today + 7,
    project_id: project.id
  }.merge(overrides))
end
