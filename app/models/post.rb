class Post < ActiveRecord::Base
  acts_as_taggable

  self.per_page = 5

  scope :latest, -> { order('created_at DESC') }
  scope :by_user, ->(user) { where(user: user) if user }
  scope :published, -> { where(published: true) }

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :body, :user_id, presence: true
  validates :title, :body, length: { minimum: 5 }
end
