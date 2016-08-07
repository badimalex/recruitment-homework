FactoryGirl.define do
  factory :post do
    sequence(:title) { |i| "Post title #{i}"}
    sequence(:body) { |i| "Post body #{i}"}
    user
  end

  factory :invalid_post, class: 'Post' do
    title nil
    body nil
  end
end
