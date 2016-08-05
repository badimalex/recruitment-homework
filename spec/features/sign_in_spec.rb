require 'rails_helper'

feature 'User sign in' do
  let(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in user

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit root_path
    click_on I18n.t('devise.sign_in')

    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content I18n.t('devise.failure.not_found_in_database', authentication_keys: I18n.t('devise.email'))
    expect(current_path).to eq new_user_session_path
  end
end
