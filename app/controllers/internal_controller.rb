class InternalController < ApplicationController
  before_action :ensure_logged_in_user

  private
  def ensure_logged_in_user
    unless current_user
      redirect_to signin_path, notice: "You must be logged in to access that action"
    end
  end

end
