require 'rails_helper'

feature "Tasks" do

  scenario "Create Task" do
    visit users_path
    click_button "Create User"
    fill_in "First Name", with: "James"
    fill_in "Last Name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "123"
    click_button "Create User"
    expect(page).to have_content("jim@email.com")
  end




end
