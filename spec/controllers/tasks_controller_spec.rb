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

  describe "#new" do
    it "doesn't allow non-project members to create" do
      session[:user_id] = @member
      @task3 = create_task(@admin_project)

      get :new, project_id: @admin_project.id

      expect(response.status).to eq(404)
    end

    it "does allow project members to create" do
      session[:user_id] = @member
      @task3 = create_task(@project)

      get :new, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "doesn't allow non-project owners to create" do
      session[:user_id] = @owner
      @task3 = create_task(@admin_project)

      get :new, project_id: @admin_project.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to create" do
      session[:user_id] = @owner
      @task = create_task(@project)

      get :new, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to create" do
      session[:user_id] = @admin
      @task2 = create_task(@admin_project)

      @task = create_task(@project)

      get :new, project_id: @admin_project.id
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

    it "does allow project owners to create" do
      session[:user_id] = @owner
      @task = create_task(@project)

      post :create, project_id: @project.id, task: {description: "foo"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("foo")
    end

    it "does allow admins to create" do
      session[:user_id] = @admin
      @task2 = create_task(@admin_project)

      post :create, project_id: @project.id, task: {description: "foo"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("foo")
    end
  end

  describe "#show" do
    it "doesn't allow non-project members to create" do
      session[:user_id] = @member
      @task3 = create_task(@admin_project)

      get :show, project_id: @admin_project.id, id: @task3.id

      expect(response.status).to eq(404)
    end

    it "does allow project members to create" do
      session[:user_id] = @member
      @task3 = create_task(@project)

      get :show, project_id: @project.id, id: @task3.id
      expect(response.status).to eq(200)
    end

    it "doesn't allow non-project owners to create" do
      session[:user_id] = @owner
      @task3 = create_task(@admin_project)

      get :show, project_id: @admin_project.id, id: @task3.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to create" do
      session[:user_id] = @owner
      @task = create_task(@project)

      get :show, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to create" do
      session[:user_id] = @admin
      @task2 = create_task(@admin_project)

      @task = create_task(@project)

      get :show, project_id: @admin_project.id, id: @task2.id
      expect(response.status).to eq(200)
    end
  end


  describe "#edit" do
    it "doesn't allow non-project members to edit" do
      session[:user_id] = @member
      @task3 = create_task(@admin_project)

      get :edit, project_id: @admin_project.id, id: @task3.id

      expect(response.status).to eq(404)
    end

    it "does allow project members to edit" do
      session[:user_id] = @member
      @task3 = create_task(@project)

      get :edit, project_id: @project.id, id: @task3.id
      expect(response.status).to eq(200)
    end

    it "doesn't allow non-project owners to edit" do
      session[:user_id] = @owner
      @task3 = create_task(@admin_project)

      get :edit, project_id: @admin_project.id, id: @task3.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to edit" do
      session[:user_id] = @owner
      @task = create_task(@project)

      get :edit, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end

    it "does allow admins to edit" do
      session[:user_id] = @admin
      @task2 = create_task(@admin_project)

      @task = create_task(@project)

      get :edit, project_id: @admin_project.id, id: @task2.id
      expect(response.status).to eq(200)
    end
  end


  describe "#update" do
    it "doesn't allow non-project members to update" do
      session[:user_id] = @member
      @task3 = create_task(@admin_project)

      patch :update, project_id: @admin_project.id, id: @task3.id
      expect(response.status).to eq(404)
    end

    it "does allow project members to update" do
      session[:user_id] = @member
      @task3 = create_task(@project)

      patch :update,  project_id: @project.id, id: @task3.id, task: {description: "furry"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("furry")
    end

    it "doesn't allow non-project owners to update" do
      session[:user_id] = @owner
      @task3 = create_task(@admin_project)

      patch :update, project_id: @admin_project.id, id:@task3.id
      expect(response.status).to eq(404)
    end

    it "does allow project owners to update" do
      session[:user_id] = @owner
      @task = create_task(@project)

      patch :update,  project_id: @project.id, id: @task.id, task: {description: "furry"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("furry")
    end

    it "does allow admins to update" do
      session[:user_id] = @admin
      @task = create_task(@project)

      patch :update,  project_id: @project.id, id: @task.id, task: {description: "furry"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("furry")
    end
  end

  describe "#destroy" do
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

    it "does allow project owners to create" do
      session[:user_id] = @owner
      @task = create_task(@project)

      post :create, project_id: @project.id, task: {description: "foo"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("foo")
    end

    it "does allow admins to create" do
      session[:user_id] = @admin
      @task2 = create_task(@admin_project)

      post :create, project_id: @project.id, task: {description: "foo"}
      task = Task.last
      expect(task.project_id).to eq(@project.id)
      expect(task.description).to eq("foo")
    end

  end


end
