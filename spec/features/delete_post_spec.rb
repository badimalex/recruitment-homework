require 'rails_helper'

feature 'Delete post' do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:another_post) { create(:post, user: create(:user)) }

  scenario 'Non-authenticated user try to edit post' do
    visit post_path(post)
    expect(page).to_not have_link I18n.t('post.delete')
  end

  scenario 'Author deletes own post' do
    sign_in user

    visit post_path(post)
    click_on I18n.t('post.delete')
    expect(page).to have_content I18n.t('post.removed')
    expect(page).to_not have_content(post.title)
    expect(current_path).to eq posts_path
  end

  scenario 'Author deletes another author post' do
    sign_in user

    visit post_path(another_post)
    expect(page).to_not have_content I18n.t('post.delete')
  end
end
