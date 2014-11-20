require 'rails_helper'

describe "User" do

  it "has unique email" do
    User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
    user = User.new(
      first_name: "Jimmy",
      last_name: "Dean",
      email: "dean@email.com",
      password: "456",
      password_confirmation: "456"
      )
    expect(user.valid?).to be(false)
    expect(user.errors[:email].present?).to eq(true)

    user = User.new(
      first_name: "Jimmy",
      last_name: "Dean",
      email: "jimmy@email.com",
      password: "456",
      password_confirmation: "456"
      )
    expect(user.valid?).to be(true)
    expect(user.errors[:email].present?).to eq(false)
  end

  it "has unique email regardless of case sensitivity" do
    user = User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
    user.email = "DEAN@email.com"
    expect(user.valid?).to be(true)
    expect(user.errors[:email].present?).to eq(false)

    user.email = "dEAN@emAIl.com"
    expect(user.valid?).to be(true)
    expect(user.errors[:email].present?).to eq(false)

  end


end
