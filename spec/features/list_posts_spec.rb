require 'rails_helper'

feature 'List posts' do
  let(:posts) { create_list(:post, 5) }

  scenario 'User can view list of posts' do
    posts
    visit posts_path

    expect(page).to have_content(I18n.t('post.title'))
    expect(page).to have_content(I18n.t('post.body'))
    expect(page).to have_content(I18n.t('post.created_at'))
    expect(page).to have_content(I18n.t('post.user'))

    posts.each do |post|
      expect(page).to have_link(post.title)
      expect(page).to have_content(post.body)
      expect(page).to have_content(post.user.email)
      expect(page).to have_content(post.created_at.strftime("%d.%m.%Y"))
    end
  end
end
