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

  scenario "Delete project" do
    Project.create!(
      name: "puppies",
    )
    visit projects_path
    expect(page).to have_content("puppies")
    click_on "puppies"
    click_on "Destroy"
    expect(page).to have_no_content("puppies")
  end

end
