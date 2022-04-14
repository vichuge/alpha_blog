class SessionsController < ApplicationController
  # skip_before_filter :authorize
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:info] = 'Logged in successfully'
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'Logged out successfully'
    redirect_to root_path
  end
end
