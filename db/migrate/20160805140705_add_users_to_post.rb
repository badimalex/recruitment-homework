class AddUsersToPost < ActiveRecord::Migration
  def change
    add_belongs_to :posts, :user, index: true, foreign_key: true
  end
end
