class CommentsController < ApplicationController
  before_action :load_post, only: [:create]

  def create
    @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_post
    @post = Post.find(params[:post_id])
  end
end
