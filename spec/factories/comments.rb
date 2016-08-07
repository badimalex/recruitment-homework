FactoryGirl.define do
  factory :comment do
    sequence(:body) { |i| "Comment body #{i}"}
    post
    user
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
    post
    user
  end
end
