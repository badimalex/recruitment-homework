require 'rails_helper'

feature 'Create post' do
  let(:user) { create(:user) }

  scenario 'Authenticated user creates a post' do
    sign_in user

    visit posts_path
    click_on I18n.t('post.add')

    fill_in 'Title', with: 'Post title'
    fill_in 'Body', with: 'Post body'
    click_on 'Create'

    expect(page).to have_content I18n.t('post.created')
  end

  scenario 'Non-authenticated user tries to create post' do
    visit posts_path
    expect(page).to_not have_link I18n.t('post.add')
  end
end
