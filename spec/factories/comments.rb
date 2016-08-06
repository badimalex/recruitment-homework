FactoryGirl.define do
  factory :comment do
    body "MyText"
    post
    user
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
    post
    user
  end
end
