require 'rails_helper'

describe UsersController do

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
      get :create
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#edit" do
    it "redirects if you aren't logged in" do
      skip
      
      get :edit
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#show" do
    it "redirects if you aren't logged in" do
      skip

      get :show
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#update" do
    it "redirects if you aren't logged in" do
      skip

      get :update
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#destroy" do
    it "redirects if you aren't logged in" do
      skip
      get :destroy
      expect(response).to redirect_to(signin_path)
    end
  end

end
