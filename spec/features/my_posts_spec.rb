require 'rails_helper'

feature 'My posts' do
  let(:user) { create(:user) }
  let(:my_posts) { create_list(:post, 2, user: user) }
  let(:other_posts) { create_list(:post, 2) }

  context 'Non-authenticated user' do
    scenario 'does not sees link for your posts' do
      visit root_path
      expect(page).to_not have_link(I18n.t('post.my'))
    end
  end

  context 'Authenticated user' do
    before do
      my_posts
      other_posts

      sign_in user
      visit root_path
    end

    scenario 'sees link for your posts' do
      expect(page).to have_link(I18n.t('post.my'))
    end

    scenario 'sees your posts' do
      click_on I18n.t('post.my')

      my_posts.each do |post|
        expect(page).to have_link(post.title)
      end
    end

    scenario 'does not sees other user posts' do
      click_on I18n.t('post.my')

      other_posts.each do |post|
        expect(page).to have_link(post.title)
      end
    end
  end
end
