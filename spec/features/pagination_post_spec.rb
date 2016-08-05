require 'rails_helper'

feature 'Paginage posts' do
  scenario 'More than 5 posts' do
    create_list :post, 6
    visit posts_path
    expect(page).to have_selector('.pagination')
  end

  scenario 'less then 5 posts' do
    create_list :post, 2
    visit posts_path
    expect(page).to_not have_selector('.pagination')
  end
end
