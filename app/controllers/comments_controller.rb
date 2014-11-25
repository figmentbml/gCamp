class CommentsController < ApplicationController
  before_action do
    @task = Task.find(params[:task_id])
  end

  def create
    if current_user
      @comment = @task.comments.new(comment_params)
      @comment.user_id = current_user.id
      @comment.task_id = @task.id
      @comment.save
    end
    redirect_to project_task_path(@task.project_id, @task)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_body, :user_id)

    # params.require(:comment).
    #   permit(:comment_body, :user_id).
    #   merge({:user_id => session[:user_id], :task_id => params[:task_id]})
  end
end
