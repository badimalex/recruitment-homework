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

    scenario 'with invalid data' do
      fill_in I18n.t('post.title'), with: nil
      fill_in I18n.t('post.body'), with: nil
      click_on I18n.t('actions.submit')

      expect(page).to have_content "#{I18n.t('activerecord.attributes.post.title')} #{I18n.t('errors.messages.blank')}"
      expect(page).to have_content "#{I18n.t('activerecord.attributes.post.title')} #{I18n.t('errors.messages.too_short.other', {count:5})}"
      expect(page).to have_content "#{I18n.t('activerecord.attributes.post.body')} #{I18n.t('errors.messages.blank')}"
      expect(page).to have_content "#{I18n.t('activerecord.attributes.post.body')} #{I18n.t('errors.messages.too_short.other', {count:5})}"
    end
  end

  scenario 'Non-authenticated user tries to create post' do
    visit posts_path
    expect(page).to_not have_link I18n.t('post.add')
  end
end
