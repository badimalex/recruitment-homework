FactoryGirl.define do
  factory :post do
    title "MyString"
    body "MyText"
  end

  factory :invalid_post, class: 'Post' do
    title nil
    body nil
  end
end
