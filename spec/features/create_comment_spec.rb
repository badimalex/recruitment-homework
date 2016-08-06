require 'acceptance_helper'

feature 'Comment a post' do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  context 'Authenticated user' do
    before do
      sign_in user
      visit post_path(post)
    end

    scenario 'comment post with valid data', js: true do
      fill_in I18n.t('comment.body'), with: 'My awesome comment body'
      click_on I18n.t('actions.submit')

      expect(current_path).to eq post_path(post)
      within '.comments' do
        expect(page).to have_content 'My awesome comment body'
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to comment post', js: true do
      visit post_path(post)
      expect(page).to_not have_content I18n.t('comment.body')
    end
  end
end
