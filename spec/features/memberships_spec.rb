require 'rails_helper'

feature "Memberships" do
  before do
    password = 'password'
    @user = create_user(password: password)

    @betty = create_user(
      first_name: "Betty",
      last_name: "Boop",
      email: "betty@email.com",
      password: password,
      )

    @max = create_user(
      first_name: "Max",
      last_name: "Mark",
      email: "max@email.com",
      password: password,
    )

    signin(@user, password)
    expect(page).to have_content("Sign Out")
    expect(page).to have_content(@user.full_name)

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
    expect(page).to have_content("Projects")
    expect(page).to have_content("Singing")
    click_on "Member"
    expect(page).to have_content("Projects")
    expect(page).to have_content("Singing")
    expect(page).to have_content("Membership")
  end

  scenario "Users can add members to projects" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Singing")
    expect(page).to have_content("Task")
    expect(page).to have_content("Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    within '.well' do
      select "Betty Boop", from: "membership_user_id"
      select "member", from: "membership_role"
      click_on "Add New Member"
    end
    expect(page).to have_no_content("error")
    expect(page).to have_content(@betty.full_name)
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
    expect(page).to have_content("Singing")
    expect(page).to have_content("Task")
    expect(page).to have_content("Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    click_on "Add New Member"
    expect(page).to have_content("User can't be blank")
  end

  scenario "Users can change role" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Singing")
    expect(page).to have_content("Task")
    expect(page).to have_content("Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    within '.well' do
      select "Betty Boop", from: "membership_user_id"
      select "member", from: "membership_role"
      click_on "Add New Member"
    end
    within 'table.table tr', text: "Betty" do
      select "Owner"
      click_on "Update"
    end
    expect(page).to have_content(@betty.full_name)
    expect(page).to have_content("Owner")
    expect(page).to have_content(" was successfully updated")
    within 'table.table tr', text: "James" do
      select "Owner"
      click_on "Update"
    end
    expect(page).to have_content(" was successfully updated")
    within 'table.table tr', text: "James" do
      find('.glyphicon').click
    end
    expect(page).to have_content("James Dean was successfully deleted")
  end

  scenario "Can't delete last owner" do
    visit projects_path
    expect(page).to have_content("Projects")
    within 'table.table' do
      click_link "Singing"
    end
    expect(page).to have_content("Singing")
    expect(page).to have_content("Task")
    expect(page).to have_content("Member")
    click_on "Member"
    expect(page).to have_content("Singing : Manage Members")
    within '.well' do
      select "Betty Boop", from: "membership_user_id"
      select "owner", from: "membership_role"
      click_on "Add New Member"
    end
    expect(page).to have_content(@betty.full_name)
    expect(page).to have_no_content('.glyphicon')
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
