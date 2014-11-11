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

  it "verifies entry of only description" do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = "Test"
    expect(task.valid?).to be(true)
  end

  it "verifies can't have old date when creating" do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = "Test"
    expect(task.valid?).to be(false)
    task.due_date = Date.today-7
    expect(task.valid?).to be(false)
    task.due_date = Date.today+7
    expect(task.valid?).to be(true)
  end

  it "verifies that task due date can be in the past when updating" do
    task = Task.new
    expect(task.valid?).to be(false)
    task.description = "Test"
    expect(task.valid?).to be(true)
    task.due_date = Date.today-7
    expect(task.valid?).to be(false)
    task = Task.update
    expect(task.valid?).to be(false)
    task.due_date = Date.today
    expect(task.valid?).to be(true)
  end

end
