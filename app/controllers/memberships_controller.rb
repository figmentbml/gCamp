class MembershipsController < ApplicationController
  before_action do
    @project = Project.find(params[:project_id])
  end

  def index
    @membership = @project.memberships.new
    @memberships = @project.memberships.all
  end

  def new
    @membership = @project.memberships.new
  end

  def create
    @membership = @project.memberships.new(membership_params)
    if @membership.save
      redirect_to project_memberships_path, notice: "Membership was successfully created"
    else
      render :new
    end
  end

  def edit
    @membership = @project.memberships.find(params[:id])
  end

  def update
    @membership = @project.memberships.find(params[:id])
    if @membership.update(membership_params)
      redirect_to project_memberships_path, notice: "Membership was successfully updated"
    else
      render :edit
    end
  end

  private

  def membership_params
    params.require(:membership).permit(
      :user_id,
      :project_id,
      :role,
    )
  end

end
