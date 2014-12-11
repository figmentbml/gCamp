require 'rails_helper'

feature "Tasks" do
  before do
    User.create!(
    first_name: "James",
    last_name: "Dean",
    email: "dean@email.com",
    password: "123",
    password_confirmation: "123"
    )
    User.create!(
    first_name: "James",
    last_name: "Lacy",
    email: "jim@email.com",
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
    fill_in "Name", with: "dogs!"
    click_button "Create Project"
    expect(page).to have_content("dogs!")
    expect(page).to have_content("Project was successfully created.")
  end

  scenario "Create Task" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "test"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("test")
    expect(page).to have_content("Task was successfully created.")
  end

  scenario "Attempt to create task w/o description" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_no_content("Task was successfully created.")
  end

  scenario "Attempt to create task w/o due date" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "test"
    click_button "Create Task"
    expect(page).to have_content("test")
    expect(page).to have_content("Task was successfully created.")
  end

  scenario "Create Task and edit from index page" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "puppies"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("puppies")
    expect(page).to have_content("Task was successfully created.")
    click_on "Edit"
    expect(page).to have_content("Edit task")
    fill_in "Description", with: "testy"
    click_button "Update Task"
    expect(page).to have_content("testy")
    expect(page).to have_no_content("puppies")
    expect(page).to have_content("Task was successfully updated.")
  end

  scenario "Can't create task with old date from index page and then update with old date" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
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
    click_button "Update Task"
    expect(page).to have_content("puppies")
    expect(page).to have_no_content("Due date can't be in the past")
    expect(page).to have_content("Task was successfully updated")
  end


  scenario "Create Task and Edit from show page" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "puppies"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("puppies")
    expect(page).to have_content("Task was successfully created")
    click_on "puppies"
    click_on "Edit"
    fill_in "Description", with: "kittens"
    click_button "Update Task"
    expect(page).to have_no_content("puppies")
    expect(page).to have_content("kittens")
    expect(page).to have_content("Task was successfully updated.")
  end

  scenario "Delete task from index page" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "puppies"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    expect(page).to have_content("puppies")
    expect(page).to have_content("Task was successfully created")
    find('.glyphicon').click
    expect(page).to have_no_content("puppies")
    expect(page).to have_content("Task was successfully destroyed")
  end

  scenario "Show all tasks from index, then incomplete tasks" do
    visit projects_path
    within '.table' do
      click_on "dogs!"
    end
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Description", with: "puppies"
    fill_in "Due date", with: "09/20/2014"
    click_button "Create Task"
    click_on "All"
    expect(page).to have_content("puppies")
    expect(page).to have_content("false")
    click_on "Incomplete"
    expect(page).to have_content("puppies")
    expect(page).to have_content("false")
  end

  scenario "Logged in users can create & see comment on task show page &
  deleted users's comments show up as (deleted user)" do
  visit projects_path
  within '.table' do
    click_link "dogs!"
  end
  click_on "Member"
  within '.well' do
    select "James Lacy", from: "membership_user_id"
    select "member", from: "membership_role"
    click_on "Add New Member"
  end
  expect(page).to have_content("successful")
  within '.breadcrumb' do
    click_link "dogs!"
  end
  click_on "Task"
  click_on "Create Task"
  fill_in "Description", with: "puppies"
  fill_in "Due date", with: "09/20/2014"
  click_button "Create Task"
  expect(page).to have_content("puppies")
  within '.table' do
    click_link "puppies"
  end
  expect(page).to have_content("puppies" && "Show" && "Comments")
  expect(page).to have_button("Add Comment")
  fill_in "comment_comment_body", with: "omg I love red collars!"
  click_on "Add Comment"
  expect(page).to have_content("omg I love red collars!")
  expect(page).to have_link("James Dean")
  fill_in "comment_comment_body", with: "I hate blue jackets"
  click_on "Add Comment"
  expect(page).to have_content("I hate blue jackets")
  expect(page).to have_link("James Dean")

  click_on "Tasks"
  within 'span.badge' do
    expect(page).to have_content('2')
  end

  visit about_path
  expect(page).to have_content("1 Project" && "1 Task" && "2 Comments" && "2 User")
  within '.nav' do
    click_on "James Dean"
  end
  click_on "Edit"
  click_on "Delete User"
  expect(page).to have_content("You must be logged in to access that action")

  visit signin_path
  fill_in "Email", with: "jim@email.com"
  fill_in "Password", with: "123"
  click_button "Sign in"
  expect(page).to have_content("Sign Out")
  expect(page).to have_content("James Lacy")

  visit projects_path
  within '.table' do
    click_on "dogs!"
  end
  click_on "Task"
  click_on "puppies"
  expect(page).to have_content("puppies")
  expect(page).to have_content("Show")
  expect(page).to have_content("Comments")
  expect(page).to have_content("(deleted user)")

  visit about_path
  expect(page).to have_content("0 Project" && "0 Task" && "0 Comments" && "1 User")
end

scenario "Users that aren't logged in can't add comments" do
  visit projects_path
  click_link "Sign Out"
  visit projects_path
  expect(page).to have_content("Sign In")
  expect(page).to have_no_button("Project")
end

scenario "Users can see breadcrumbs on task index & show pages" do
  visit projects_path
  within '.table' do
    click_on "dogs!"
  end
  click_on "Task"
  within '.breadcrumb' do
    expect(page).to have_content("Projects")
    expect(page).to have_content("dogs!")
    expect(page).to have_content("Task")
  end
  click_on "Create Task"
  fill_in "Description", with: "puppies"
  fill_in "Due date", with: "09/20/2014"
  click_button "Create Task"
  expect(page).to have_content("puppies")
  within '.table' do
    click_on "puppies"
  end
  expect(page).to have_content("puppies")
  within '.breadcrumb' do
    expect(page).to have_content("Projects")
    expect(page).to have_content("dogs!")
    expect(page).to have_content("Task")
    expect(page).to have_content("Show")
  end
  expect(page).to have_content("Comments")
  expect(page).to have_no_link("Back")
  expect(page).to have_content("Edit")
end


end
