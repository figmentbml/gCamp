class InternalController < ApplicationController
  before_action :ensure_logged_in_user
  before_action :admin?
  before_action :projects

  private
  def ensure_logged_in_user
    unless current_user
      redirect_to signin_path, notice: "You must be logged in to access that action"
    end
  end

  def projects
    @projects = Project.all
  end

end
