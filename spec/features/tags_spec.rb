require 'rails_helper'

feature 'Tags' do
  let(:user) { create(:user) }
  let(:tags) { ['Tag1', 'Tag2', 'Tag3'] }
  let(:tagged_post) { create(:post, title: 'Tagged post', tag_list: tags.join(', ')) }
  let(:not_tagged_post) { create(:post, title: 'Post without tags') }

  scenario 'adding' do
    sign_in user
    visit posts_path
    click_on I18n.t('post.add')

    fill_in I18n.t('post.title'), with: 'Post title'
    fill_in I18n.t('post.body'), with: 'Post body'
    fill_in I18n.t('post.tag_list'), with: tags.join(', ')

    click_on I18n.t('actions.submit')

    expect(page).to have_content I18n.t('post.created')

    tags.each do |tag|
      expect(page).to have_link tag
    end
  end

  context 'searching' do
    before do
      tagged_post
      not_tagged_post
      visit root_path
    end

    scenario 'sees tags cloud' do
      tags.each do |tag|
        expect(page).to have_link tag
      end
    end

    scenario 'clicking on tag' do
      click_on 'Tag1'
      expect(page).to have_link tagged_post.title
      expect(page).to_not have_link not_tagged_post.title
    end
  end
end
