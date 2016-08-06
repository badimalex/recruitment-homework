require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  shared_examples 'user access to comments' do
    describe 'POST #create' do
      let(:commentable) { create(:post) }

      context 'with valid attributes' do
        it 'saves the new comment in the database' do
          expect { post :create, comment: attributes_for(:comment), post_id: commentable }.to \
            change(commentable.comments, :count).by(1)
        end

        it 'redirect to post show' do
          post :create, comment: attributes_for(:comment), post_id: commentable
          expect(response).to redirect_to post_path(commentable)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect { post :create, comment: attributes_for(:invalid_comment), post_id: commentable }.to_not \
            change(Comment, :count)
        end

        it 'redirect to post show' do
          post :create, comment: attributes_for(:invalid_comment), post_id: commentable
          expect(response).to redirect_to post_path(commentable)
        end
      end
    end
  end

  describe 'user access' do
    sign_in_user

    before do
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it_behaves_like 'user access to comments'
  end

  describe 'guest access' do
    describe 'POST #create' do
      it 'redirects to login' do
        post :create, comment: attributes_for(:comment), post_id: create(:post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
