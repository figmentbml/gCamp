require 'rails_helper'

describe TasksController do
  describe "#index" do
    it "doesn't allow non-logged in users to view" do
      skip
      get :index, project_id: @project.id

      expect(response).to redirect_to(signin_path)
    end
  end

  describe "#new" do
    it "doesn't allow non-logged in users to view" do
      skip
      get :new, project_id: @project.id

      expect(response).to redirect_to(signin_path)
    end
  end

end
