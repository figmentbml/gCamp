require 'rails_helper'

feature "Sign In" do

  scenario "Sign In with valid inputs" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit signin_path
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    click_button "Sign in"
    expect(page).to have_content("Sign Out")
    expect(page).to have_content("James Lacy")
  end

  scenario "Sign In without email" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit root_path
    click_on "Sign In"
    fill_in "Password", with: "123"
    click_button "Sign in"
    expect(page).to have_content("Username / password combination is invalid")
    expect(page).to have_content("Sign In")
  end

  scenario "Sign in without password" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit root_path
    click_on "Sign In"
    fill_in "Email", with: "jim@email.com"
    click_button "Sign in"
    expect(page).to have_content("Username / password combination is invalid")
    expect(page).to have_content("Sign In")
    expect(page).to have_no_content("Sign Out")
  end

  scenario "Sign in & out" do
    User.create!(
      first_name: "James",
      last_name: "Lacy",
      email: "jim@email.com",
      password: "123",
      password_confirmation: "123"
    )
    visit root_path
    click_on "Sign In"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    click_button "Sign in"
    expect(page).to have_content("James Lacy")
    expect(page).to have_no_content("Sign Up")

    click_on "Sign Out"
    expect(page).to have_no_content("James Lacy")
    expect(page).to have_content("Sign In")
  end



end
