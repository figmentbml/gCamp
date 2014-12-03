class ProjectsController < InternalController
  before_action :project_id_match, except: [:index, :new, :create]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to project_tasks_path(@project), notice: "Project was successfully created."
      Membership.create(project_id: @project.id, user_id: current_user.id, role: "owner")
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
    if owner?.empty?
      render 'public/404', status: :not_found, layout: false
    end
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    if @project.save
      redirect_to projects_path, notice: "Project was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if owner?.empty?
      render 'public/404', status: :not_found, layout: false
    else
      @project.destroy
      redirect_to projects_path, notice: "Project was successfully deleted."
    end
  end

  private

  def project_params
    params.required(:project).permit(:name)
  end

end
