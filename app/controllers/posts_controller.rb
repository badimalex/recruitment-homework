class PostsController < ApplicationController
  include PublicIndex, PublicShow

  before_action :load_post, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def index
    @posts = Post.latest.published.paginate(page: params[:page])
  end

  def show
    @comment = @post.comments.build
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, flash: { notice: t('post.created') }
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, flash: { notice: t('post.removed') }
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published)
  end

  def check_owner
    redirect_to @post unless current_user.author_of?(@post)
  end
end
