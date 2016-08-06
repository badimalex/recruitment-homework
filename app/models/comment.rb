class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :body, :user_id, presence: true

  def expired?
    created_at > DateTime.now + 15.minutes
  end
end
