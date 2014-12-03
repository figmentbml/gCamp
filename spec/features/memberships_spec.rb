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
    User.create!(
    first_name: "Betty",
    last_name: "Boop",
    email: "betty@email.com",
    password: "123",
    password_confirmation: "123"
    )
    visit signin_path
    fill_in "Email", with: "dean@email.com"
    fill_in "Password", with: "123"
    click_button "Sign in"
    expect(page).to have_content("Sign Out")
    expect(page).to have_content("James Dean")

    click_on "Create Project"
    fill_in "Name", with: "Singing"
    click_button "Create Project"
    expect(page).to have_content("Singing")
    expect(page).to have_content("Project was successfully created.")
  end

  scenario "Users can see breadcrumbs on membership index" do
    visit projects_path
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Projects" && "Singing")
    click_on "Member"
    expect(page).to have_content("Projects" && "Singing" && "Membership")
  end

  scenario "Users can add members to projects" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Singing" && "Task" && "Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    within '.well' do
      select "Betty Boop", from: "membership_user_id"
      select "member", from: "membership_role"
      click_on "Add New Member"
    end
    expect(page).to have_no_content("error")
    expect(page).to have_content("Betty Boop")
    expect(page).to have_content("member")
    expect(page).to have_button("Update")
    expect(page).to have_content("Betty Boop was successfully created")
  end

  scenario "Users must select users and roles for memberships" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Singing" && "Task" && "Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    click_on "Add New Member"
    expect(page).to have_content("User can't be blank")
  end

  scenario "Users can change role and delete" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Singing" && "Task" && "Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    within '.table' do
      select "member", from: "membership_role"
      click_on "Update"
    end
    expect(page).to have_content("James Dean")
    expect(page).to have_content("member")
    expect(page).to have_content(" was successfully updated")
    within '.well' do
      select "Betty Boop", from: "membership_user_id"
      select "member", from: "membership_role"
      click_on "Add New Member"
    end
    expect(page).to have_content("Betty Boop was successfully created")
    within '.table tr', text: 'Betty' do
      find('.glyphicon').click
    end
    expect(page).to have_content("Betty Boop was successfully deleted")
  end

  scenario "Users cannot add the same member to a project twice" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    click_link "Member"
    within '.well' do
      select "James Dean", from: "membership_user_id"
      select "owner", from: "membership_role"
      click_on "Add New Member"
    end
    expect(page).to have_content("User should only have one membership per project")
  end

end
