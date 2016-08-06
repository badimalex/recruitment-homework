module AcceptanceMacros
  def sign_in(user)
    visit root_path
    click_on I18n.t('devise.sign_in')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end
