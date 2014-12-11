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
      post :create
      expect(response).to redirect_to(signin_path)
    end

  end

  describe "#edit" do
    xit "redirects if you aren't logged in" do
      get :edit
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#show" do
    xit "redirects if you aren't logged in" do
      get :show
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#update" do
    xit "redirects if you aren't logged in" do
      patch :update
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#destroy" do
    xit "redirects if you aren't logged in" do
      delete :destroy
      expect(response).to redirect_to(signin_path)
    end
  end

end
