require 'acceptance_helper'

feature 'Delete comment' do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { create(:comment, user: user, post: post) }
  let(:another_comment) { create(:comment, user: create(:user), post: post) }

  scenario 'Non-authenticated user' do
    comment
    visit post_path(post)

    within '.comments' do
      expect(page).to_not have_link I18n.t('actions.delete')
    end
  end

  scenario 'Authenticated user', js: true do
    sign_in user
    comment
    visit post_path(post)

    within '.comments' do
      click_on I18n.t('actions.delete')
      expect(page).to_not have_content(comment.body)
      expect(current_path).to eq post_path(post)
    end
  end

  scenario 'When non comment author' do
    sign_in user
    another_comment
    visit post_path(post)

    within '.comments' do
      expect(page).to_not have_link I18n.t('actions.delete')
    end
  end
end
