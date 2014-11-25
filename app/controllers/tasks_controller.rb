class TasksController < ApplicationController
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @project.tasks.where(complete: false)
    @ref = "incomplete"
    if params[:type] == "all"
      @tasks = @project.tasks
      @ref = "all"
    end
  end

  def show
    @comment = @task.comments.new
    @comments = @task.comments.all
  end

  def new
    @task = @project.tasks.new
  end

  def edit
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      redirect_to project_tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    @task.update(task_params)
      if @task.save
        redirect_to project_tasks_path, notice: 'Task was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @task.destroy
    redirect_to project_tasks_path, notice: 'Task was successfully destroyed.'
  end

  private
    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:description, :complete, :due_date)
    end
end
