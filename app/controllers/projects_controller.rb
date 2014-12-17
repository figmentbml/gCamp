class ProjectsController < InternalController
  before_action :project_id_match, except: [:index, :new, :create, :tracker_stories]

  def index
    @projects = Project.all
    tracker_api = TrackerAPI.new
    @tracker_projects = tracker_api.projects(current_user.tracker_token)
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
    unless owner?.present? || admin?
      raise AccessDenied
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
    unless owner?.present? || admin?
      raise AccessDenied
    else
      @project.destroy
      redirect_to projects_path, notice: "Project was successfully deleted."
    end
  end

  def tracker_stories
    tracker_api = TrackerAPI.new
    @tracker_projects = tracker_api.projects(current_user.tracker_token)
    @tracker_stories = tracker_api.stories(params[:tracker_id], current_user.tracker_token)
    @tracker_project = tracker_api.project(params[:tracker_id], current_user.tracker_token)
  end

  private

  def project_params
    params.required(:project).permit(:name)
  end

end
