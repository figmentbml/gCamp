require 'rails_helper'

describe ProjectsController do
  before do
    password = 'password'
    @user = create_user(password: password)

    @admin = create_user(
    first_name: "Betty",
    last_name: "Boop",
    email: "betty@email.com",
    password: password,
    admin: true
    )

    @member = create_user(
    first_name: "Minnie",
    last_name: "Mouse",
    email: "minnie@email.com",
    password: password,
    )

    @owner = create_user(
    first_name: "Max",
    last_name: "Mark",
    email: "max@email.com",
    password: password,
    )

    @project = Project.create!(
    name: "Acme"
    )

    @admin_project = create_project

    @owner_membership = create_membership(@project, @owner, "owner")
    @admin_membership = create_membership(@admin_project, @admin)
    @member_membership = create_membership(@project, @member, "member")

  end

  describe "#index" do
    it "does not allow visitors" do
      get :index

      expect(response).to redirect_to(signin_path)
    end

    it "does allow members to view" do
      session[:user_id] = @member.id

      get :index

      expect(response.status).to eq(200)
    end

    it "does allow owners to view" do
      session[:user_id] = @owner.id

      get :index

      expect(response.status).to eq(200)
    end

    it "does allow admins to view" do
      session[:user_id] = @admin.id

      get :index

      expect(response.status).to eq(200)
    end

    it "does allow logged-in users to view" do
      session[:user_id] = @user.id

      get :index

      expect(response.status).to eq(200)
    end
  end

  describe "#new" do
    it "does not allow visitors" do
      get :new

      expect(response).to redirect_to(signin_path)
    end

    it "does allow members to view" do
      session[:user_id] = @member.id

      get :new

      expect(response.status).to eq(200)
    end

    it "does allow owners to view" do
      session[:user_id] = @owner.id

      get :new

      expect(response.status).to eq(200)
    end

    it "does allow admins to view" do
      session[:user_id] = @admin.id

      get :new

      expect(response.status).to eq(200)
    end

    it "does allow logged-in users to view" do
      session[:user_id] = @user.id

      get :new

      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    it "does not allow visitors" do
      @silly_project = Project.create!(
      name: "Silly"
      )

      post :create, project: {name: "Silly"}

      expect(response).to redirect_to(signin_path)
    end

    it "does allow members" do
      session[:user_id] = @member.id

      @silly_project = Project.create!(
      name: "Silly"
      )

      post :create, project: {name: "Silly"}

      expect(response.status).to eq(302)
    end

    it "does allow owners" do
      session[:user_id] = @owner.id

      @silly_project = Project.create!(
      name: "Silly"
      )

      post :create, project: {name: "Silly"}

      expect(response.status).to eq(302)
    end

    it "does allow admins" do
      session[:user_id] = @admin.id

      @silly_project = Project.create!(
      name: "Silly"
      )

      post :create, project: {name: "Silly"}

      expect(response.status).to eq(302)
    end

    it "does allow logged-in users" do
      session[:user_id] = @user.id

      @silly_project = Project.create!(
      name: "Silly"
      )

      post :create, project: {name: "Silly"}

      expect(response.status).to eq(302)
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
      session[:user_id] = @admin.id

      get :edit, id: @project.id

      expect(response.status).to eq(200)
    end

  end

  describe "#update" do
    it "does not allow non-members" do
      session[:user_id] = @user.id

      patch :update, id: @project.id, project: {name: 'foo'}

      expect(response.status).to eq(404)
    end

    it "does not allow members" do
      @membership = create_membership(@project, @user, "member")

      session[:user_id] = @user.id

      patch :update, id: @project.id, project: {name: 'foo'}

      expect(Project.last.name).to eq('Singing')
    end

    it "does allow owners" do
      Membership.create!(
      user: @user,
      project: @project,
      role: 'owner'
      )
      session[:user_id] = @user.id

      patch :update, id: @project.id, project: {name: 'foo'}

      expect(response.status).to eq(302)
    end

    it "does allow admins" do
      session[:user_id] = @admin.id

      patch :update, id: @project.id, project: {name: 'foo'}

      expect(response.status).to eq(302)
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
      session[:user_id] = @admin.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(Project.count).to eq(count - 1)
      expect(response).to redirect_to(projects_path)
    end

    it "allows owners to delete" do
      @membership = create_membership(@project, @user, "owner")
      @membership3 = create_membership(@project, @admin, "owner")

      session[:user_id] = @user.id
      count = Project.count

      delete :destroy, id: @project.id

      expect(Project.count).to eq(count - 1)
      expect(response).to redirect_to(projects_path)
    end

  end
end
