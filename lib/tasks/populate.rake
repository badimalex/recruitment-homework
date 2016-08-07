namespace :db do
  desc "Erase and fill database with fake data"
  task populate: :environment do
    require 'factory_girl_rails'
    [Post, Comment, User].each(&:delete_all)

    FactoryGirl.create(:user, email: 'test@user.com', password: '12345678', password_confirmation: '12345678')

    7.times do
      post = FactoryGirl.create(:post, user: FactoryGirl.create(:user))
      3.times do |comment|
        FactoryGirl.create(:comment, post: post, user: FactoryGirl.create(:user))
      end
    end
  end
end
