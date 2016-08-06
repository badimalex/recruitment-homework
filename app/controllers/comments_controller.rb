class CommentsController < ApplicationController
  before_action :load_comment, only: [:update, :destroy]
  before_action :load_post, only: [:create, :update]
  before_action :check_owner, only: [:update, :destroy]

  def create
    @comment = @post.comments.create(comment_params.merge(user: current_user))
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy unless @comment.expired?
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def load_post
    @post = Post.find(params[:post_id])
  end

  def check_owner
    unless current_user.author_of?(@comment)
      redirect_to new_user_session_path
    end
  end
end
