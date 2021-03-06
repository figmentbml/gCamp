class MembershipsController < InternalController
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :current_user, only: [:show, :destroy]
  before_action :tasks_id_match
  before_action :not_owner_render_404, only: [:new, :create, :edit, :update]

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
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully created"
    else
      @memberships = @project.memberships.all
      render :index
    end
  end

  def edit
    @membership = @project.memberships.find(params[:id])
  end


  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      redirect_to project_memberships_path,
      notice: "#{@membership.user.full_name} was successfully updated"
    else
      redirect_to project_memberships_path,
      notice: "You can't change the membership on the last owner."
    end
  end

  def destroy
    @membership = Membership.find(params[:id])

    if @membership.destroy
      if current_user_has_membership?
        redirect_to projects_path,
        notice: "#{@membership.user.full_name} was successfully deleted"
      else
        redirect_to project_memberships_path,
        notice: "#{@membership.user.full_name} was successfully deleted"
      end
    else
      redirect_to project_memberships_path,
      notice: "You can't delete the last owner.  Please add another owner first."
    end
  end

  def current_membership
    Membership.where(user_id: current_user.id, project_id: @project.id).first
  end

  helper_method :current_membership


  private

  def membership_params
    params.require(:membership).permit(
    :user_id,
    :project_id,
    :role
    )
  end

  def not_owner_render_404
    return false if admin?
    if owner?.empty?
      raise AccessDenied
    end
  end

  def current_user_has_membership?
    @membership.user.id == current_user.id
  end

end
