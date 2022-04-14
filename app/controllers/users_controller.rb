class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy show]
  before_action :require_user, only: %i[edit update destroy]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 1)
  end

  def new
    @user = User.new
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Alpha Blog #{@user.username}"
      session[:user_id] = @user.id
      redirect_to articles_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:info] = 'Your account was successfully updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:danger] = 'User and all articles created by user have been deleted'
    else
      flash[:info] = 'There was an error deleting the user'
    end
    session[:user_id] = nil if @user == current_user
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = 'You can only edit or delete your own account'
      redirect_to @user
    end
  end
end
