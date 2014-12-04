require 'rails_helper'

describe TasksController do
  describe "#index" do
    it "doesn't allow non-logged in users to view" do
      skip
      get :index

      expect(response).to redirect_to(signin_path)
    end
  end
end
