require 'rails_helper'

feature "Users" do
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

  scenario "Edit User from Users Index" do
    visit users_path
    expect(page).to have_content("dean@email.com")

    within 'table tr', text: "James Dean" do
      click_on "Edit"
    end
    fill_in "Email", with: "james@email.com"
    click_button "Update User"
    expect(page).to have_content("James")
    expect(page).to have_content("Dean")
    expect(page).to have_content("james@email.com")
  end

  scenario "Edit User from User Show" do
    visit users_path
    expect(page).to have_content("dean@email.com")

    within 'table tr', text: "James Dean" do
      click_on "James Dean"
    end
    click_on "Edit"
    fill_in "Email", with: "james@email.com"
    click_button "Update User"
    expect(page).to have_content("James")
    expect(page).to have_content("Dean")
    expect(page).to have_content("james@email.com")

  end

  scenario "Delete User" do
    visit users_path
    expect(page).to have_content("dean@email.com")
    within 'table tr', text: "James Dean" do
      click_on "Edit"
    end
    click_on "Delete User"
    expect(page).to have_no_content("dean@email.com")
  end

  scenario "Show User" do
    visit users_path
    expect(page).to have_content("dean@email.com")
    within 'table tr', text: "James Dean" do
      click_on "James Dean"
    end
    expect(page).to have_content("dean@email.com")
    expect(page).to have_content("James Dean")
  end

end
