require 'rails_helper'

feature "Sign Up" do

  scenario "Sign Up with valid inputs" do
    visit root_path
    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "123"
    click_button "Sign Up"
    expect(page).to have_content("James Lacy")
    expect(page).to have_content("Sign Out")
  end

  scenario "Sign Up without email" do
    visit root_path
    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "123"
    click_button "Sign Up"
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Sign Up")
  end

  scenario "Sign Up without password confirmation" do
    visit root_path
    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    click_button "Sign Up"
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content("Sign Up")
    expect(page).to have_no_content("Sign Out")
  end

  scenario "Sign Up without password" do
    visit root_path
    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password confirmation", with: "123"
    click_button "Sign Up"
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Sign Up")
    expect(page).to have_no_content("Sign Out")
  end

  scenario "Sign Up with different password & password confirmation" do
    visit root_path
    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "456"
    click_button "Sign Up"
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content("Sign Up")
    expect(page).to have_no_content("Sign Out")
  end

  scenario "Sign out and then sign up w/ same email" do
    visit root_path
    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "123"
    fill_in "Password confirmation", with: "123"
    click_button "Sign Up"
    expect(page).to have_content("James Lacy")
    expect(page).to have_no_content("Sign Up")

    click_on "Sign Out"
    expect(page).to have_no_content("James Lacy")
    expect(page).to have_content("Sign Up")

    click_on "Sign Up"
    fill_in "First name", with: "James"
    fill_in "Last name", with: "Lacy"
    fill_in "Email", with: "jim@email.com"
    fill_in "Password", with: "456"
    fill_in "Password confirmation", with: "456"
    click_button "Sign Up"
    expect(page).to have_content("Email has already been taken")
    expect(page).to have_content("Sign Up")
    expect(page).to have_no_content("Sign Out")
  end

end
