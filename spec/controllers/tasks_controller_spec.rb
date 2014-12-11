require 'rails_helper'

describe TasksController do
  before do
    password = 'password'
    @owner = create_user(password: password)

    @admin = create_user(
    first_name: "Betty",
    last_name: "Boop",
    email: "betty@email.com",
    password: password,
    admin: true
    )

    @member = create_user(
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
    before do
      @task = create_task(@project)
      @task2 = create_task(@admin_project)
    end
    it "doesn't allow non-logged in users to view" do
      get :index, project_id: @project.id

      expect(response).to redirect_to(signin_path)
    end

    it "doesn't allow non-project members to view" do
      session[:user_id] = @member

      get :index, project_id: @admin_project.id
      expect(response.status).to eq(404)
    end

    it "does allow project members to view" do
      session[:user_id] = @member

      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "doesn't allow non-project owners to view" do
      session[:user_id] = @owner

      get :index, project_id: @admin_project.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to view" do
      session[:user_id] = @owner

      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to view" do
      session[:user_id] = @admin

      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    it "doesn't allow non-project members to create" do
      session[:user_id] = @member
      @task3 = create_task(@admin_project)

      post :create, project_id: @admin_project.id
      expect(response.status).to eq(404)
    end

    it "does allow project members to create" do
      session[:user_id] = @member

      post :create,  project_id: @project.id, task: {description: "foo"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("foo")
    end

    it "doesn't allow non-project owners to create" do
      session[:user_id] = @owner
      @task3 = create_task(@admin_project)

      post :create, project_id: @admin_project.id
      expect(response.status).to eq(404)
    end

    xit "does allow project owners to create" do
      session[:user_id] = @owner
      @task = create_task(@project)

      post :create, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to create" do
      skip
      session[:user_id] = @admin
      @task2 = create_task(@admin_project)

      post :create, project_id: @project.id
      expect(response.status).to eq(200)
    end
  end


end
