require 'rails_helper'

describe "Membership" do

  it "verifies entry of all fields" do
    User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
    Project.create!(
      name: "Singing"
    )
    membership = Membership.new
    expect(membership.valid?).to be(false)
    membership.user_id = User.last.id
    expect(membership.valid?).to be(false)
    membership.role = 'owner'
    expect(membership.valid?).to be(true)
  end

  it "verifies error messages for no user selected" do
    User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
    Project.create!(
      name: "Singing"
    )
    membership = Membership.new
    expect(membership.valid?).to be(false)
    membership.user_id = "Please select a user..."
    expect(membership.valid?).to be(false)
    membership.role = 'owner'
    expect(membership.errors.present?).to eq(true)
  end

  it "verifies error messages for multiple memberships for same user within project" do
    User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
    Project.create!(
      name: "Singing"
    )
    membership = Membership.new
    expect(membership.valid?).to be(false)
    membership.user_id = User.last.id
    expect(membership.valid?).to be(false)
    membership.role = 'owner'
    expect(membership.valid?).to be(true)
    expect(membership.errors.present?).to eq(false)

    membership = Membership.new
    expect(membership.valid?).to be(false)
    membership.user_id = User.last.id
    expect(membership.valid?).to be(false)
    membership.role = 'member'
    expect(membership.errors.present?).to eq(true)
  end
end
