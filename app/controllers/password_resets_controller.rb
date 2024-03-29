class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user 
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "please check your email for a password reset link"
      redirect_to root_path
    else
      flash.now[:danger] = "email not found"
      render 'new'
    end
  end
  

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "password has been reset"
      redirect_to @user
      @user.update_columns(reset_digest: nil, sent_at: nil)
    else render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && 
            @user.activated? && 
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'link has expired'
      redirect_to new_password_reset_path
    end
  end
end
