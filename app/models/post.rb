class Post < ActiveRecord::Base
  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 5 }
end
