class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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

  def edit
  end

  def update
    @user.update(user_params)
    @user.save
    redirect_to users_path, notice: "User was successfully updated."
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User was successfully deleted."
  end


  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(
    :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation
    )
  end

end
