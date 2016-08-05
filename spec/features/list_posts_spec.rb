require 'rails_helper'

feature 'List posts' do
  let(:posts) { create_list(:post, 5) }

  scenario 'User can view list of posts' do
    posts
    visit posts_path

    posts.each do |post|
      expect(page).to have_link(post.title)
    end
  end
end
