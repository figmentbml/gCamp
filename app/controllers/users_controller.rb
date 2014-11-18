class UsersController < ApplicationController
  before_action do
    @membership = Membership.find(params[:user_id])
  end
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = @membership.users
  end

  def new
    @user = @membership.user.new
  end

  def create
    @user = @membership.user.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.update(user_params)
    if @user.save
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User was successfully deleted."
  end


  private
  def set_user
    @user = @membership.user.find(params[:id])
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
