class MembershipsController < ApplicationController

  def index
    @memberships = Membership.all
  end

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      redirect_to Membership
    else
      render :new
    end
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      redirect_to Membership
    else
      render :edit
    end
  end

  private

  def membership_params
    params.require(:membership).permit(
      :user_id,
      :project_id,
      :type
    )
  end

end
