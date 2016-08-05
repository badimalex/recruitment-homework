require 'rails_helper'

feature 'User sign out' do
  let(:user) { create(:user) }

  scenario 'Authorized user try to sign out' do
    sign_in user

    click_on I18n.t('devise.sign_out')
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
    expect(current_path).to eq root_path
  end

  scenario 'Non authorized doesnt see signout button' do
    visit root_path
    expect(page).to_not have_link I18n.t('devise.sign_out')
  end
end
