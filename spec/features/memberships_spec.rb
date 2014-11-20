require 'rails_helper'

feature "Memberships" do

  scenario "Users can see breadcrumbs on membership index" do
    User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
    Project.create!(
      name: "Singing"
    )
    visit projects_path
    click_on "Singing"
    expect(page).to have_content("Projects" && "Singing")
    click_on "Member"
    expect(page).to have_content("Projects" && "Singing" && "Membership")
  end


end
