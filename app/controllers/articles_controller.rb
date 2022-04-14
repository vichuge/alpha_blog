class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :require_user, except: %i[index shown welcome]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    # render plain: params[:article]
    @article = Article.new(article_params)
    @article.user = current_user
    # render plain: @article.inspect
    # article.errors.full_messages
    if @article.save
      flash[:success] = 'Article was successfully created'
      redirect_to @article
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:info] = 'Article was successfully updated'
      redirect_to @article
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    flash[:danger] = 'Article was successfully deleted'
    redirect_to articles_path
  end

  def welcome
    redirect_to articles_path if logged_in?
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:danger] = 'You can only edit or delete your own articles'
      redirect_to articles_path
    end
  end
end
