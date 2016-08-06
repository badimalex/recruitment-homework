class MyPostsController < ApplicationController
  def index
    @posts = Post.by_user current_user
  end
end
