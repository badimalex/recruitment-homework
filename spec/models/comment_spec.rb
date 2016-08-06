require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :post }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  describe '.expired?' do
    let(:comment) { create(:comment) }
    let(:expired_comment) { create(:comment, created_at: DateTime.now + 16.minutes) }

    it 'when created more then 15 min return true' do
      expect(expired_comment.expired?).to be true
    end

    it 'when created less then 15 min return false' do
      expect(comment.expired?).to be false
    end
  end
end
