require 'rails_helper'

feature "Users" do

  scenario "Create User" do
    visit users_path
    click_on "Create User"
    fill_in "First Name", with: "James"
    fill_in "Last Name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "123"
    click_button "Create User"
    expect(page).to have_content("jim@email.com")
    expect(page).to have_content("James")
    expect(page).to have_content("Lacy")

  end

end
