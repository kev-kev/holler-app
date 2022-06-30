class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "welcome to the sample app!"
      redirect_to @user
    else
      render new_user_path, status: 400
    end
  end

  def index
    @users = User.all
  end

  def update
    if @user.update(user_params)
      flash[:success] = "successfully updated profile"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
