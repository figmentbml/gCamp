require 'rails_helper'

feature "Memberships" do
  before do
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
  end

  scenario "Users can see breadcrumbs on membership index" do
    visit projects_path
    click_on "Singing"
    expect(page).to have_content("Projects" && "Singing")
    click_on "Member"
    expect(page).to have_content("Projects" && "Singing" && "Membership")
  end

  scenario "Users can add members to projects" do
    visit projects_path
    expect(page).to have_content("Projects")
    click_on "Singing"
    expect(page).to have_content("Singing" && "Task" && "Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    select "James Dean", from: "membership_user_id"
    select "member", from: "membership_role"
    click_on "Add New Member"
    expect(page).to have_no_content("error")
    expect(page).to have_content("James Dean")
    expect(page).to have_content("member")
    expect(page).to have_button("Update")
    expect(page).to have_content(" was successfully created")
  end

  scenario "Users must select users and roles for memberships" do
    visit projects_path
    expect(page).to have_content("Projects")
    click_on "Singing"
    expect(page).to have_content("Singing" && "Task" && "Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    click_on "Add New Member"
    expect(page).to have_content("User can't be blank")
  end

  scenario "Users can change role and delete" do
    visit projects_path
    expect(page).to have_content("Projects")
    click_on "Singing"
    expect(page).to have_content("Singing" && "Task" && "Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    select "James Dean", from: "membership_user_id"
    select "member", from: "membership_role"
    click_on "Add New Member"
    expect(page).to have_no_content("error")
    expect(page).to have_content("James Dean")
    expect(page).to have_content("member")
    expect(page).to have_button("Update")
    expect(page).to have_content(" was successfully created")

    within '.table' do
       select "owner", from: "membership_role"
    end
    click_on "Update"
    expect(page).to have_content("James Dean")
    expect(page).to have_content("owner")
    expect(page).to have_content(" was successfully updated")

    find('.glyphicon').click
    expect(page).to have_content(" was successfully deleted")
  end

  scenario "Users cannot add the same member to a project twice" do
    visit projects_path
    expect(page).to have_content("Projects")
    click_on "Singing"
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    select "James Dean", from: "membership_user_id"
    select "member", from: "membership_role"
    click_on "Add New Member"
    expect(page).to have_no_content("error")
    expect(page).to have_content("James Dean")
    expect(page).to have_content("member")
    expect(page).to have_button("Update")
    expect(page).to have_content(" was successfully created")

    select "James Dean", from: "membership_user_id"
    within '.table' do
       select "owner", from: "membership_role"
    end
    click_on "Add New Member"
    expect(page).to have_content("User should only have one membership per project")
  end

end
