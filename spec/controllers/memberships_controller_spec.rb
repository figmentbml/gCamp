require 'rails_helper'

describe MembershipsController do
  before do
    @user = User.create!(
    first_name: "James",
    last_name: "Dean",
    email: "dean@email.com",
    password: "123",
    password_confirmation: "123"
    )

    @project = Project.create!(
    name: "Acme"
    )
  end

  describe "#index" do
    it "doesn't allow non-logged in users to view" do
      get :index, project_id: @project.id

      expect(response).to redirect_to(signin_path)
    end

    it "doesn't allow non-members in users to view" do
      session[:user_id] = @user.id

      get :index, project_id: @project.id

      expect(response.status).to eq(404)
    end


    it "doesn't allow members to update membership role" do
      @membership = Membership.create!(
        user: @user,
        project: @project,
        role: 'member'
      )

      session[:user_id] = @user.id

      patch :update, project_id: @project.id, id: @membership.id

      expect(response.status).to eq(404)
    end

    it "allows owners to update membership role" do
      betty = User.create(
      first_name: "Betty",
      last_name: "Boop",
      email: "betty@email.com",
      password: "123",
      password_confirmation: "123"
      )

      betty_membership = Membership.create(
      user: betty,
      project: @project,
      role: 'member'
      )

      @membership = Membership.create!(
        user: @user,
        project: @project,
        role: 'owner'
      )

      session[:user_id] = @user.id

      patch :update, project_id: @project.id, id: betty_membership.id, membership:{role: 'owner'}

      expect(response.status).to eq(302)
    end
  end

end
