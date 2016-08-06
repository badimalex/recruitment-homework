require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:commentable) { create(:post) }

  shared_examples 'user access to comments' do
    describe 'POST #create' do
      let(:comment) { create(:comment, user: @user) }

      context 'with valid attributes' do
        it 'saves the new comment in the database' do
          expect { post :create, comment: attributes_for(:comment), post_id: commentable, format: :js }.to \
            change(commentable.comments, :count).by(1)
        end

        it 'render create template' do
          post :create, comment: attributes_for(:comment), post_id: commentable, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect { post :create, comment: attributes_for(:invalid_comment), post_id: commentable, format: :js  }.to_not \
            change(Comment, :count)
        end

        it 'render create template' do
          post :create, comment: attributes_for(:invalid_comment), post_id: commentable, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'PATCH #update' do
      let(:comment) { create(:comment, post: commentable, user: @user) }

      it 'assigns the requested comment to @comment' do
        patch :update, id: comment, comment: attributes_for(:comment), post_id: commentable, format: :js
        expect(assigns(:comment)).to eq comment
      end

      it 'assigns the post' do
        patch :update, id: comment, comment: attributes_for(:comment), post_id: commentable, format: :js
        expect(assigns(:post)).to eq commentable
      end

      it 'render update template' do
        patch :update, id: comment, comment: attributes_for(:comment), post_id: commentable, format: :js
        expect(response).to render_template :update
      end

      context 'User update own comment' do
        it 'updates comment in the database' do
          patch :update, id: comment, comment: { body: 'new body' }, post_id: commentable, format: :js
          comment.reload
          expect(comment.body).to eq 'new body'
        end
      end

      context 'User update other user comment' do
        let(:other_user) { create(:user) }
        let(:other_comment) { create(:comment, body: 'Old value', user: other_user, post: commentable) }

        it "doesn't updates comment in the database" do
          other_comment
          patch :update, id: other_comment, comment: { body: 'New value' }, post_id: commentable, format: :js
          other_comment.reload
          expect(assigns(:comment).body).to eq 'Old value'
        end
      end
    end

    describe 'Delete #destroy' do
      let(:comment) { create(:comment, post: commentable, user: @user) }

      it 'renders the :destroy template' do
        delete :destroy, id: comment, post_id: commentable, format: :js
        expect(response).to render_template :destroy
      end

      context 'Author deletes own comment' do
        it 'deletes comment' do
          comment
          expect { delete :destroy, id: comment, post_id: commentable, format: :js }.to \
            change(@user.comments, :count).by(-1)
        end
      end

      context 'Author deletes another author comment' do
        let(:other_user) { create(:user) }
        let(:other_comment) { create(:comment, user: other_user) }

        it "doesn't deletes the comment" do
          other_comment
          expect { delete :destroy, id: other_comment, post_id: commentable }.to_not change(Comment, :count)
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
        post :create, comment: attributes_for(:comment), post_id: commentable
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH #update' do
      let(:comment) { create(:comment) }

      it 'redirects to login' do
        patch :update, id: comment, comment: attributes_for(:comment), post_id: commentable
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to login' do
        delete :destroy, id: create(:post), post_id: commentable
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
