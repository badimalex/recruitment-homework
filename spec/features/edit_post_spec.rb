require 'rails_helper'

feature I18n.t('actions.edit') do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:another_post) { create(:post, user: create(:user)) }

  scenario 'Non-authenticated user try to edit post' do
    visit post_path(post)
    expect(page).to_not have_link I18n.t('actions.edit')
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit post_path(post)
    end

    scenario 'sees link to edit post' do
      expect(page).to have_link(I18n.t('actions.edit'))
    end

    scenario 'try to edit post with invalid data' do
      click_on I18n.t('actions.edit')

      fill_in 'Title', with: nil
      fill_in 'Body', with: nil
      click_on I18n.t('actions.submit')

      expect(page).to have_content post.body
      expect(page).to have_selector 'textarea'
    end

    scenario 'try to edit post' do
      click_on I18n.t('actions.edit')
      fill_in 'Title', with: 'Edited post'
      fill_in 'Body', with: 'My awesome edited body'
      fill_in 'Created at', with: DateTime.tomorrow.strftime("%Y/%m/%d")

      click_on I18n.t('actions.submit')

      expect(page).to_not have_content post.body
      expect(page).to have_content 'Edited post'
      expect(page).to have_content 'My awesome edited body'
      within '.post' do
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Authenticated user try to edit other user post' do
    sign_in user
    another_post

    visit post_path(another_post)
    expect(page).to_not have_content I18n.t('actions.edit')
  end
end
