class MembershipsController < InternalController
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :current_user, only: [:show, :destroy]
  before_action :tasks_id_match
  before_action :not_owner_render_404, only: [:new, :create, :edit, :update, :destroy]


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
      redirect_to project_memberships_path, notice: "#{@membership.user.full_name} was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    redirect_to project_memberships_path, notice: "#{@membership.user.full_name} was successfully deleted"
  end

  private

  def membership_params
    params.require(:membership).permit(
    :user_id,
    :project_id,
    :role
    )
  end

  def not_owner_render_404
    if owner?.empty?
      render 'public/404', status: :not_found, layout: false
    end
  end

end
