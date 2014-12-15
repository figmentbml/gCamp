require 'rails_helper'

describe UsersController do
  before do
    password = 'password'
    @user = create_user(password: password)
  end

  describe "#index" do
    it "redirects if you aren't logged in" do
      get :index
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#new" do
    it "redirects if you aren't logged in" do
      get :new
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#create" do
    it "redirects if you aren't logged in" do
      post :create
      expect(response).to redirect_to(signin_path)
    end

  end

  describe "#edit" do
    it "redirects if you aren't logged in" do
      get :edit, id: @user.id
      expect(response).to redirect_to(signin_path)
    end

    it "allows users to edit their self" do
    end

    it "allows admins to update users with admin true" do
    end
  end

  describe "#show" do
    it "redirects if you aren't logged in" do
      get :show, id: @user.id
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#update" do
    it "redirects if you aren't logged in" do
      patch :update, id: @user.id
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#destroy" do
    it "redirects if you aren't logged in" do
      delete :destroy, id: @user.id
      expect(response).to redirect_to(signin_path)
    end
  end

end
