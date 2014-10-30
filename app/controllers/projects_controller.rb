class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.save
    redirect_to projects_path, notice: "Project was successfully created."
  end

  def edit
  end

  def update
  end

  def destroy
  end

private

  def project_params
    params.required(:project).permit(:name)
  end

end
