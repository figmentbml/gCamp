require 'rails_helper'

feature "Projects" do

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
    visit root_path
    click_on "Projects"
    click_on "Create Project"
    click_button "Create Project"
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_no_content("Project was successfully created.")
  end

  scenario "Create Project and edit" do
    visit root_path
    click_on "Projects"
    click_on "Create Project"
    fill_in "Name", with: "cats"
    click_button "Create Project"
    expect(page).to have_content("cats")
    expect(page).to have_content("Project was successfully created.")
    click_on "Edit"
    fill_in "Name", with: "awesome sauce"
    click_button "Update Project"
    expect(page).to have_no_content("cats")
    expect(page).to have_content("awesome sauce")
    expect(page).to have_content("Project was successfully updated.")
  end

  scenario "Delete project, deletes related tasks" do
    Project.create!(
      name: "dogs!",
    )
    visit projects_path
    click_on "dogs!"
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "take for a walk"
    fill_in "Due date", with: Date.today+7
    click_button "Create Task"
    expect(page).to have_content("take for a walk")
    expect(page).to have_content("Task was successfully created.")
    visit projects_path
    click_on "dogs!"
    expect(page).to have_content("1 Task")
    # within 'span.badge' do
    #   expect(page).to have_content("1")
    # end

    visit about_path
    expect(page).to have_content("1 Project, 1 Task")

    visit projects_path
    expect(page).to have_content("dogs!")
    click_on "dogs!"
    within '.well' do
      expect(page).to have_content("Deleting this project will also delete")
      click_on "Delete"
    end
    expect(page).to have_no_content("dogs!")

    visit about_path
    expect(page).to have_content("0 Project" && "0 Task")
  end

end
