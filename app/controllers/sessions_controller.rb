  class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in and redirect to user show page
    else
      # throw error
      flash.now[:danger] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
  end
end
