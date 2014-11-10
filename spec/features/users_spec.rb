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

  scenario "Users must have first name, last name, and email" do
    visit users_path
    click_on "Create User"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "123"
    click_button "Create User"
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")

  end

  scenario "Edit User from Users Index" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit users_path
    expect(page).to have_content("jim@email.com")

    click_on "Edit"
    fill_in "Email", with: "james@email.com"
    click_button "Update User"
    expect(page).to have_content("James")
    expect(page).to have_content("Lacy")
    expect(page).to have_content("james@email.com")

  end

  scenario "Edit User from User Show" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit users_path
    expect(page).to have_content("jim@email.com")

    click_on "James Lacy"
    click_on "Edit"
    fill_in "Email", with: "james@email.com"
    click_button "Update User"
    expect(page).to have_content("James")
    expect(page).to have_content("Lacy")
    expect(page).to have_content("james@email.com")

  end

  scenario "Delete User" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit users_path
    expect(page).to have_content("jim@email.com")
    click_on "Edit"
    click_on "Delete User"
    expect(page).to have_no_content("jim@email.com")
  end

  scenario "Show User" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit users_path
    expect(page).to have_content("jim@email.com")
    click_on "James Lacy"
    expect(page).to have_content("jim@email.com")
    expect(page).to have_content("James Lacy")
  end



end
