require 'rails_helper'

describe UsersController do
  before do
    password = 'password'
    @user = create_user(password: password)

    @owner = create_user(
    first_name: "Crazy",
    last_name: "Pants",
    email: "crazy@email.com",
    password: password,
    admin: true
    )

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
    it "redirects if you aren't logged in" do
      get :index

      expect(response).to redirect_to(signin_path)
    end

    it "allows users to see themselves" do
      session[:user_id] = @member.id

      get :index
      expect(response.status).to eq(200)
    end

    it "allows admins to see everything" do
      session[:user_id] = @admin.id

      get :index
      expect(response.status).to eq(200)
    end

  end

  describe "#new" do
    it "redirects if you aren't logged in" do
      get :new

      expect(response).to redirect_to(signin_path)
    end

    it "allows users to create their self" do
      session[:user_id] = @member.id

      get :new
      expect(response.status).to eq(200)
    end

    it "does not allow users to create others" do
      session[:user_id] = @member.id

      get :new
      expect(response.status).to eq(200)
    end

    it "allows admins to create users" do
      session[:user_id] = @admin.id

      get :new
      expect(response.status).to eq(200)
    end

  end

  describe "#create" do
    it "redirects if you aren't logged in" do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it "does not allow users to create others" do
      session[:user_id] = @member.id
      password = 'password'

      post :create, user: {
        first_name: "Mickey",
        last_name: "Mouse",
        email: "mickey@email.com",
        password: password}
      expect(response.status).to eq(302)
    end

    it "allows admins to create users" do
      session[:user_id] = @admin.id
      password = 'password'

      post :create, user: {
        first_name: "Mickey",
        last_name: "Mouse",
        email: "mickey@email.com",
        password: password}
        expect(response.status).to eq(302)
    end

  end

  describe "#show" do
    it "redirects if you aren't logged in" do
      get :show, id: @user.id
      expect(response).to redirect_to(signin_path)
    end

    it "allows users to see themselves" do
      session[:user_id] = @member.id

      get :show, id: @member.id
      expect(response.status).to eq(200)
    end

    it "allows admins to see everything" do
      session[:user_id] = @admin.id

      get :show, id: @user.id
      expect(response.status).to eq(200)
    end

  end

  describe "#edit" do
    it "redirects if you aren't logged in" do
      get :edit, id: @user.id
      expect(response).to redirect_to(signin_path)
    end

    it "allows users to edit their self" do
      session[:user_id] = @member.id

      get :edit, id: @member.id
      expect(response.status).to eq(200)
    end

    it "does not allow users to edit others" do
      session[:user_id] = @member.id

      get :edit, id: @user.id
      expect(response.status).to eq(404)
    end

    it "allows admins to edit users" do
      session[:user_id] = @admin.id

      get :edit, id: @user.id
      expect(response.status).to eq(200)
    end
  end

  describe "#update" do
    it "redirects if you aren't logged in" do
      patch :update, id: @user.id
      expect(response).to redirect_to(signin_path)
    end

    it "allows users to update their self" do
      session[:user_id] = @member.id

      patch :update, id: @member.id, user: {last_name: "Silly"}
      expect(response.status).to eq(302)
    end

    it "does not allow users to update others" do
      session[:user_id] = @member.id

      patch :update, id: @user.id
      expect(response.status).to eq(404)
    end

    it "allows admins to update users" do
      session[:user_id] = @admin.id

      patch :update, id: @member.id, user: {last_name: "Silly"}
      expect(response.status).to eq(302)
    end

  end

  describe "#destroy" do
    it "redirects if you aren't logged in" do
      delete :destroy, id: @user.id
      expect(response).to redirect_to(signin_path)
    end

    it "allows users to delete their self" do
      session[:user_id] = @member.id

      delete :destroy, id: @member.id
      expect(response.status).to eq(302)
    end

    it "does not allow users to delete others" do
      session[:user_id] = @member.id

      delete :destroy, id: @user.id
      expect(response.status).to eq(404)
    end

    it "allows admins to delete users" do
      session[:user_id] = @admin.id

      delete :destroy, id: @user.id
      expect(response.status).to eq(302)
    end

  end

end
