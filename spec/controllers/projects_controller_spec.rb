require 'rails_helper'

describe ProjectsController do
  before do
    password = 'password'
    @user = create_user(password: password)

    @betty = create_user(
    first_name: "Betty",
    last_name: "Boop",
    email: "betty@email.com",
    password: password,
    admin: true
    )

    @max = create_user(
    first_name: "Max",
    last_name: "Mark",
    email: "max@email.com",
    password: password,
    )

    @project = Project.create!(
    name: "Acme"
    )

    @project2 = create_project

    @betty_membership = create_membership(@project2, @betty)

  end

  describe "#index" do
    it "doesn't allow non-logged in users to view" do
      get :index

      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#edit" do
    it "does not allow non-members" do
      session[:user_id] = @user.id

      get :edit, id: @project.id

      expect(response.status).to eq(404)
    end

    it "does not allow members" do
      @membership = create_membership(@project, @user, "member")

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
      session[:user_id] = @betty.id

      get :edit, id: @project.id

      expect(response.status).to eq(200)
    end

  end

  describe "#destroy" do

    it "does not allow non-members" do
      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(response.status).to eq(404)
      expect(count).to eq(Project.count)
    end

    it "does not allow project members" do
      @membership = create_membership(@project, @user, "member")

      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(response.status).to eq(404)
      expect(count).to eq(Project.count)
    end

    it "allows admins to delete" do
      session[:user_id] = @betty.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(Project.count).to eq(count - 1)
      expect(response).to redirect_to(projects_path)
    end

    it "allows owners to delete" do
      @membership = create_membership(@project, @user, "owner")
      @membership3 = create_membership(@project, @betty, "owner")

      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(Project.count).to eq(count - 1)
      expect(response).to redirect_to(projects_path)
    end

  end
end
