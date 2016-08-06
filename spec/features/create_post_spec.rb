require 'rails_helper'

feature 'Create post' do
  let(:user) { create(:user) }

  context 'Authenticated user creates a post' do
    before do
      sign_in user
      visit posts_path
      click_on I18n.t('post.add')
    end

    scenario 'published' do
      fill_in I18n.t('post.title'), with: 'Post published'
      fill_in I18n.t('post.body'), with: 'Post body'

      click_on I18n.t('actions.submit')

      expect(page).to have_content I18n.t('post.created')
      visit posts_path
      expect(page).to have_link 'Post published'
    end

    scenario 'not published' do
      fill_in I18n.t('post.title'), with: 'Post not published'
      fill_in I18n.t('post.body'), with: 'Post body'
      page.uncheck I18n.t('post.published')
      click_on I18n.t('actions.submit')

      expect(page).to have_content I18n.t('post.created')
      visit posts_path
      expect(page).to_not have_link 'Post not published'
    end
  end

  scenario 'Non-authenticated user tries to create post' do
    visit posts_path
    expect(page).to_not have_link I18n.t('post.add')
  end
end
