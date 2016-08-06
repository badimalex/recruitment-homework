require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should have_db_column(:published).of_type(:boolean) }

  describe '.latest' do
    before do
      @first = create(:post, created_at: 1.day.ago)
      @last  = create(:post, created_at: 4.day.ago)
    end

    it 'should return posts in the correct order' do
      expect(Post.latest).to eq [@first, @last]
    end
  end

  describe '.published' do
    before do
      @published = create(:post)
      @not_published  = create(:post, published: false)
    end

    it 'return array include published posts' do
      expect(Post.published).to include(@published)
    end

    it 'return array without not published posts' do
      expect(Post.published).to_not include(@not_published)
    end
  end

  describe '.by_user' do
    before do
      @user = create(:user)
      @user_posts = create_list(:post, 2, user: @user)
      @other_posts = create_list(:post, 2)
    end

    it 'should include user posts' do
      expect(Post.by_user(@user)).to match_array(@user_posts)
    end

    it 'should not include other user posts' do
      expect(Post.by_user(@user)).to_not match_array(@other_posts)
    end
  end

  describe '.per_page' do
    it { expect(Post.per_page).to eq 5 }
  end
end
