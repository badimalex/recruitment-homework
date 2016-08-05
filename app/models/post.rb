class Post < ActiveRecord::Base
  self.per_page = 5

  scope :latest, -> { order('created_at DESC') }
  scope :by_user, ->(user) { where(user: user) if user }

  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, :body, length: { minimum: 5 }
end
