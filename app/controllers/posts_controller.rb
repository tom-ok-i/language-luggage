class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to user_path(current_user), notice: "新規投稿が完了しました"
    else
      render:new
    end
  end

  def index
    @posts = Post.page(params[:page]).per(10).reverse_order
    @genres = Genre.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def update
    if@post.update(post_params)
      redirect_to user_path(current_user), notice: "投稿情報の編集が完了しました"
    else
      render:edit
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(current_user), notice: "投稿の削除が完了しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :image, :genre_id)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

end
