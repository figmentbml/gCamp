require 'rails_helper'

feature "Tasks" do

  scenario "Create Task" do
    visit root_path
    click_on "Tasks"
    click_on "Create Task"
    fill_in "Description", with: "test"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("test")
    expect(page).to have_content("Task was successfully created.")
  end

  scenario "Attempt to create task w/o description" do
    visit root_path
    click_on "Tasks"
    click_on "Create Task"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_no_content("Task was successfully created.")
  end

  scenario "Attempt to create task w/o due date" do
    visit root_path
    click_on "Tasks"
    click_on "Create Task"
    fill_in "Description", with: "test"
    click_button "Create Task"
    expect(page).to have_content("test")
    expect(page).to have_content("Task was successfully created.")
  end

  scenario "Create Task and edit from show page" do
    visit root_path
    click_on "Tasks"
    click_on "Create Task"
    fill_in "Description", with: "puppies"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("puppies")
    expect(page).to have_content("Task was successfully created.")
    click_on "Edit"
    fill_in "Description", with: "testy"
    check "Complete"
    click_button "Update Task"
    expect(page).to have_content("testy")
    expect(page).to have_no_content("puppies")
    expect(page).to have_content("Complete: true")
  end

  scenario "Can't create task with old date from show page and then update with old date" do
    visit root_path
    click_on "Tasks"
    click_on "Create Task"
    fill_in "Description", with: "puppies"
    fill_in "Due date", with: Date.today-7
    click_button "Create Task"
    expect(page).to have_no_content("puppies")
    expect(page).to have_content("Due date can't be in the past")
    fill_in "Due date", with: Date.today+14
    click_button "Create Task"
    click_on "Edit"
    fill_in "Due date", with: Date.today-5
    check "Complete"
    click_button "Update Task"
    expect(page).to have_content("puppies")
    expect(page).to have_no_content("Due date can't be in the past")
    expect(page).to have_content("Task was successfully updated")
  end


  scenario "Create Task and Edit from index page" do
    Task.create!(
      description: "puppies",
      due_date: "09/20/2014",
    )
    visit tasks_path
    expect(page).to have_content("puppies")
    click_on "Edit"
    fill_in "Description", with: "kittens"
    click_button "Update Task"
    expect(page).to have_no_content("puppies")
    expect(page).to have_content("kittens")
    expect(page).to have_content("Task was successfully updated.")
    click_on "Back"
    expect(page).to have_content("Tasks")
  end

  scenario "Delete task from index page" do
    Task.create!(
      description: "puppies",
      due_date: "09/20/2014",
    )
    visit tasks_path
    expect(page).to have_content("puppies")
    click_on "Destroy"
    expect(page).to have_no_content("puppies")
  end

  scenario "Show all tasks from index" do
    Task.create!(
      description: "puppies",
      due_date: "09/20/2014",
    )
    visit tasks_path
    click_on "Edit"
    check "Complete"
    click_button "Update Task"
    click_on "Back"
    click_on "All"
    expect(page).to have_content("puppies")
    expect(page).to have_content("true")
  end

  scenario "Show all tasks from index, then incomplete tasks" do
    Task.create!(
      description: "puppies",
      due_date: "09/20/2014",
    )
    visit tasks_path
    click_on "All"
    expect(page).to have_content("puppies")
    expect(page).to have_content("false")
    click_on "Incomplete"
    expect(page).to have_content("puppies")
    expect(page).to have_content("false")
  end


end
