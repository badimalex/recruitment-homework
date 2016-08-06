FactoryGirl.define do
  factory :comment do
    body "MyText"
    post
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
    post
  end
end
