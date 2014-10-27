class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
    redirect_to users_path, notice: 'User was successfully created.'
  end

private
  def user_params
    params.required(:user).permit(:first_name, :last_name, :email)
  end

end
