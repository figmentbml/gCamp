require 'rails_helper'

describe "Task" do

  it "verifies entry of all fields" do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = "Test"
    expect(task.valid?).to be(true)
    task.due_date = '11/11/3012'
    expect(task.valid?).to be(true)
  end

  it "verifies can't have old date when creating" do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = "Test"
    expect(task.valid?).to be(true)
    task.due_date = Date.today-7
    expect(task.valid?).to be(false)
    expect(task.errors[:due_date].present?).to eq(true)

    task.due_date = Date.today+7
    expect(task.valid?).to be(true)
    expect(task.errors[:due_date].present?).to eq(false)
  end

  it "verifies can have old date when updating" do
    task = Task.create!(description: "Test")
    expect(task.errors[:description].present?).to eq(false)
    task.due_date = Date.today-7
    expect(task.valid?).to be(true)
    expect(task.errors[:due_date].present?).to eq(false)

    task.due_date = Date.today+7
    expect(task.valid?).to be(true)
    expect(task.errors[:due_date].present?).to eq(false)
  end


end
