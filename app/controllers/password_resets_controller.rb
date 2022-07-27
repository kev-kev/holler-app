class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  
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

  private
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
end
