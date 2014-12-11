require 'rails_helper'

describe TasksController do
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

    @project2 = create_project #should call it admin_project

    @membership = create_membership(@project, @user, "owner") #call owner_membership
    @betty_membership = create_membership(@project2, @betty) #call admin_membership
    @max_membership = create_membership(@project, @max, "member") #call member_membership
  end

  describe "#index" do
    before do
      @task = create_task(@project)
      @task2 = create_task(@project2)
    end
    it "doesn't allow non-logged in users to view" do
      get :index, project_id: @project.id

      expect(response).to redirect_to(signin_path)
    end

    it "doesn't allow non-project members to view" do
      session[:user_id] = @max

      get :index, project_id: @project2.id
      expect(response.status).to eq(404)
    end

    it "does allow project members to view" do
      session[:user_id] = @max

      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "doesn't allow non-project owners to view" do
      session[:user_id] = @user

      get :index, project_id: @project2.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to view" do
      session[:user_id] = @user

      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to view" do
      session[:user_id] = @betty

      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    it "doesn't allow non-project members to create" do
      session[:user_id] = @max
      @task3 = create_task(@project2)

      post :create, project_id: @project2.id
      expect(response.status).to eq(404)
    end

    it "does allow project members to create" do
      session[:user_id] = @max

      post :create,  project_id: @project.id, task: {description: "foo"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("foo")
    end

    it "doesn't allow non-project owners to create" do
      session[:user_id] = @user
      @task3 = create_task(@project2)

      post :create, project_id: @project2.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to create" do
      skip
      session[:user_id] = @user
      @task = create_task(@project)

      post :create, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to create" do
      skip
      session[:user_id] = @betty
      @task2 = create_task(@project2)

      post :create, project_id: @project.id
      expect(response.status).to eq(200)
    end
  end


end
