require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }

    let(:another_user) { create(:user) }
    let(:another_post) { create(:post, user: another_user) }

    it 'returns true, if is author of post' do
      expect(user).to be_author_of(post)
    end
  end
end
