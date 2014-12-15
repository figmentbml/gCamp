require 'rails_helper'

describe MembershipsController do
  before do
    password = 'password'

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

    @member = create_user(
    first_name: "Minnie",
    last_name: "Mouse",
    email: "minnie@email.com",
    password: password,
    )

    @owner = create_user(
    first_name: "Max",
    last_name: "Mark",
    email: "max@email.com",
    password: password,
    )

    @admin = create_user(
    first_name: "Crazy",
    last_name: "Pants",
    email: "crazy@email.com",
    password: password,
    admin: true
    )

    @betty = User.create(
    first_name: "Betty",
    last_name: "Boop",
    email: "betty@email.com",
    password: "123",
    password_confirmation: "123"
    )

    @owner_membership = create_membership(@project, @owner, "owner")
    @member_membership = create_membership(@project, @member, "member")
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

    it "does allow members to view" do
      session[:user_id] = @member.id

      get :index, project_id: @project.id

      expect(response.status).to eq(200)
    end

    it "does allow owners to view" do
      session[:user_id] = @owner.id

      get :index, project_id: @project.id

      expect(response.status).to eq(200)

    end

    it "does allow admins to view" do
      session[:user_id] = @admin.id

      get :index, project_id: @project.id

      expect(response.status).to eq(200)

    end
  end

  describe "#update" do
    it "doesn't allow members to update membership role" do
      @membership = Membership.create!(
        user: @user,
        project: @project,
        role: 'member'
      )

      session[:user_id] = @user.id

      patch :update, project_id: @project.id, id: @membership.id, membership: {role: 'member'}

      expect(response.status).to eq(404)
    end

    it "allows owners to update membership role" do

      betty_membership = Membership.create(
      user: @betty,
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

    it "allows admins to update membership role" do

      betty_membership = Membership.create(
      user: @betty,
      project: @project,
      role: 'member'
      )

      @membership = Membership.create!(
      user: @user,
      project: @project,
      role: 'owner'
      )

      session[:user_id] = @admin.id

      patch :update, project_id: @project.id, id: betty_membership.id, membership:{role: 'owner'}

      expect(response.status).to eq(302)
    end
  end

  describe "#create" do
    it "allows project owners to create memberships" do
      session[:user_id] = @owner.id

      betty_membership = Membership.create(
      user: @betty,
      project: @project,
      role: 'member'
      )

      post :create, project_id: @project.id, id: betty_membership.id, membership: {role: 'member'}

      expect(Membership.last.id).to eq(betty_membership.id)
    end

    it "allows admins to create memberships" do
      session[:user_id] = @admin.id

      betty_membership = Membership.create(
      user: @betty,
      project: @project,
      role: 'member'
      )

      post :create, project_id: @project.id, id: betty_membership.id, membership: {role: 'member'}

      expect(Membership.last.id).to eq(betty_membership.id)
    end

    it "does not allow members to create memberships" do
      session[:user_id] = @member.id

      post :create, project_id: @project.id, id: @betty.id, membership: {role: 'member'}

      expect(Membership.last.user_id).to_not eq(@betty.id)

    end
  end

  describe "#destroy" do
    it "allows members to delete their own memberships" do
      session[:user_id] = @member.id
      count = Membership.count

      delete :destroy, project_id: @project.id, id: @member_membership.id

      expect(count-1).to eq(Membership.count)
    end

    it "does not allow owners to delete the last owner" do
      session[:user_id] = @owner.id
      count = Membership.count

      delete :destroy, project_id: @project.id, id: @owner_membership.id

      expect(Membership.count).to eq(count)

    end

    it "does allow owners to delete membership if not last owner" do
      session[:user_id] = @owner.id

      @betty_membership = Membership.create(
      user: @betty,
      project: @project,
      role: 'owner'
      )

      count = Membership.count

      delete :destroy, project_id: @project.id, id: @betty_membership.id

      expect(Membership.count).to eq(count-1)
    end

    it "does not allow admins to delete the last owner" do
      session[:user_id] = @admin.id
      count = Membership.count

      delete :destroy, project_id: @project.id, id: @owner_membership.id

      expect(Membership.count).to eq(count)
    end

    it "does allow admins to delete the owners (not last)" do
      session[:user_id] = @admin.id

      @betty_membership = Membership.create(
      user: @betty,
      project: @project,
      role: 'owner'
      )

      count = Membership.count

      delete :destroy, project_id: @project.id, id: @betty_membership.id

      expect(Membership.count).to eq(count-1)
    end

    it "does allow admins to delete the members" do
      session[:user_id] = @admin.id
      count = Membership.count

      delete :destroy, project_id: @project.id, id: @member_membership.id

      expect(count-1).to eq(Membership.count)
    end
  end
end
