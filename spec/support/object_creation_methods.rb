def create_user(overrides = {})
  User.create!(
    {
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
    }.merge(overrides)
  )
end

def create_membership(project, user, overrides = {})
  Membership.create!({
    user_id: @user.id,
    project_id: @project.id,
    role: 'owner',
  }.merge(overrides))
end

def create_project(overrides = {})
  Project.create!({
    name: "Singing",
  }.merge(overrides))
end
