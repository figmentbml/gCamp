require 'rails_helper'

describe ProjectsController do

  describe "#edit" do
    before do
      @user = User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
      @project = Project.create!(
      name: "Acme"
      )
    end

    it "does not allow non-members" do
      session[:user_id] = @user.id

      get :edit, id: @project.id

      expect(response.status).to eq(404)
    end

    it "does not allow members" do
      Membership.create!(
      user: @user,
      project: @project,
      role: 'member'
      )
      session[:user_id] = @user.id

      get :edit, id: @project.id

      expect(response.status).to eq(404)
    end

    it "does allow owners" do
      Membership.create!(
      user: @user,
      project: @project,
      role: 'owner'
      )
      session[:user_id] = @user.id

      get :edit, id: @project.id

      expect(response.status).to eq(200)
    end

    it "does allow admins" do
    end

  end

  describe "#destroy" do

    before do
      @user = User.create!(
      first_name: "James",
      last_name: "Dean",
      email: "dean@email.com",
      password: "123",
      password_confirmation: "123"
      )
      @project = Project.create!(
      name: "Acme"
      )
    end

    it "does not allow non-members" do
      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(response.status).to eq(404)
      expect(count).to eq(Project.count)
    end

    it "does not allow project members" do
      Membership.create!(
      user: @user,
      project: @project,
      role: 'member'
      )
      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(response.status).to eq(404)
      expect(count).to eq(Project.count)
    end

    it "allows admins to delete" do
      skip
      Membership.create!(
      user: @user,
      project: @project,
      role: 'owner'
      )
      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(count).to eq(count - 1)
      expect(response).to redirect_to(projects_path)
    end

    it "allows owners to delete" do
      skip
      Membership.create!(
      user: @user,
      project: @project,
      role: 'owner'
      )
      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(count).to eq(count - 1)
      expect(response).to redirect_to(projects_path)
    end

  end
end
