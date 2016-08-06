require 'acceptance_helper'

feature 'comment editing' do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { create(:comment, user: user, post: post) }
  let(:another_comment) { create(:comment, user: create(:user), post: post) }

  context 'Authenticated' do
    before do
      sign_in user
      comment
      visit post_path(post)
    end

    scenario 'sees link to edit comment' do
      within '.comments' do
        expect(page).to have_link I18n.t('actions.edit')
      end
    end

    scenario 'try to edit his comment', js: true do
      within '.comments' do
        click_on I18n.t('actions.edit')

        fill_in I18n.t('comment.body'), with: 'My awesome edited comment body'
        click_on I18n.t('actions.submit')

        expect(page).to_not have_content comment.body
        expect(page).to have_content 'My awesome edited comment body'
        expect(page).to_not have_selector 'textarea.comment_body'
      end
    end
  end

  context 'Non-authenticated' do
    scenario 'does not sees link for edit comment' do
      visit post_path(post)

      within '.comments' do
        expect(page).to_not have_link I18n.t('actions.edit')
      end
    end
  end

  scenario 'Author try to edit other author comment' do
    sign_in user
    another_comment
    visit post_path(post)

    within '.comments' do
      expect(page).to_not have_link I18n.t('actions.edit')
    end
  end
end
