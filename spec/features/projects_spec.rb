require 'rails_helper'

feature "Projects" do
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
  end

  scenario "Create Project" do
    visit root_path
    click_on "Projects"
    click_on "Create Project"
    fill_in "Name", with: "cats"
    click_button "Create Project"
    expect(page).to have_content("cats")
    expect(page).to have_content("Project was successfully created.")
  end

  scenario "Attempts to create project w/o name" do
    visit projects_path
    click_on "Create Project"
    click_button "Create Project"
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_no_content("Project was successfully created.")
  end

  scenario "Create Project and edit" do
    visit projects_path
    click_on "Create Project"
    fill_in "Name", with: "cats"
    click_button "Create Project"
    expect(page).to have_content("cats")
    expect(page).to have_content("Project was successfully created.")
    within '.breadcrumb' do
      click_link "cats"
    end
    click_on "Edit"
    fill_in "Name", with: "awesome sauce"
    click_button "Update Project"
    expect(page).to have_no_content("cats")
    expect(page).to have_content("awesome sauce")
    expect(page).to have_content("Project was successfully updated.")
  end

  scenario "Delete project, deletes related tasks" do
    skip
    visit projects_path
    click_on "Create Project"
    fill_in "Name", with: "dogs!"
    click_button "Create Project"
    expect(page).to have_content("dogs!")
    expect(page).to have_content("Project was successfully created.")
    within '.breadcrumb' do
      click_link "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "take for a walk"
    fill_in "Due date", with: Date.today+7
    click_button "Create Task"
    expect(page).to have_content("take for a walk")
    expect(page).to have_content("Task was successfully created.")
    visit projects_path
    within '.table' do
      click_link "dogs!"
    end
    expect(page).to have_content("1 Task")

    visit about_path
    expect(page).to have_content("1 Project")
    expect(page).to have_content("1 Task")

    visit projects_path
    expect(page).to have_content("dogs!")
    within '.table' do
      click_link "dogs!"
    end
    within '.well' do
      expect(page).to have_content("Deleting this project will also delete")
      click_link "Delete"
    end
    expect(page).to have_no_content("dogs!")

    visit about_path
    expect(page).to have_content("0 Project")
    expect(page).to have_content("0 Task")
  end

end
