require 'rails_helper'

feature 'View post' do
  let(:post) { create(:post) }

  scenario 'User can view a post' do
    post

    visit posts_path
    click_on post.title

    expect(page).to have_content(post.title)
    expect(page).to have_content(post.body)
  end
end
