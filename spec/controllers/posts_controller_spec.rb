require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  shared_examples_for 'public access to posts' do
    describe 'GET #index' do
      let(:posts) { create_list(:post, 2) }

      before { get :index }

      it 'populates an array of all posts' do
        expect(assigns(:posts)).to match_array(posts)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      let(:post) { create(:post) }

      before { get :show, id: post }

      it 'assigns the requested post to @post' do
        expect(assigns(:post)).to eq post
      end

      it 'assigns new comment for post' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end
  end

  shared_examples 'user access to posts' do
    describe 'GET #new' do
      before { get :new }

      it 'assigns a new post to @post' do
        expect(assigns(:post)).to be_a_new(Post)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      let(:post) { create(:post) }
      before { get :edit, id: post }

      it 'assigns the requested post to @post' do
        expect(assigns(:post)).to eq post
      end

      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new post in the database' do
          expect { post :create, post: attributes_for(:post) }.to change(@user.posts, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, post: attributes_for(:post)
          expect(response).to redirect_to post_path(assigns(:post))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the post' do
          expect { post :create, post: attributes_for(:invalid_post) }.to_not change(Post, :count)
        end

        it 're-renders show view' do
          post :create, post: attributes_for(:invalid_post)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      let(:post) { create(:post, user: @user, title: 'Original title', body: 'Original body') }

      context 'with valid attributes' do
        it 'assigns the requested post to @post' do
          patch :update, id: post, post: attributes_for(:post)
          expect(assigns(:post)).to eq post
        end

        it 'updates post in the database' do
          patch :update, id: post, post: { title: 'new title', body: 'new body' }
          post.reload
          expect(post.title).to eq 'new title'
          expect(post.body).to eq 'new body'
        end

        it 'redirects to the updated post' do
          patch :update, id: post, post: attributes_for(:post)
          expect(response).to redirect_to post
        end
      end

      context 'with invalid attributes' do
        before { patch :update, id: post, post: attributes_for(:invalid_post) }

        it 'does not update post' do
          post.reload
          expect(post.title).to eq 'Original title'
          expect(post.body).to eq 'Original body'
        end

        it 're-renders #edit tempalte' do
          expect(response).to redirect_to edit_post_path(post)
        end
      end

      context 'when not the owner' do
        let(:another_user) { create(:user) }
        let(:another_post) { create(:post, user: another_user, body: 'Original post body') }

        it "doesn't update post" do
          another_post
          patch :update, id: another_post, post: { title: 'new title', body: 'new body for post' }

          another_post.reload
          expect(another_post.body).to eq 'Original post body'
        end
      end
    end

    describe 'Delete #destroy' do
      let(:post) { create(:post, user: @user) }

      context 'Author deletes own post' do
        it 'deletes post' do
          post
          expect { delete :destroy, id: post }.to change(@user.posts, :count).by(-1)
        end
        it 'redirect to index view' do
          delete :destroy, id: post
          expect(response).to redirect_to posts_path
        end
      end

      context 'Author deletes another author post' do
        let(:another_user) { create(:user) }
        let(:another_post) { create(:post, user: another_user) }

        it "doesn't deletes a post" do
          another_post
          expect { delete :destroy, id: another_post }.to_not change(Post, :count)
        end

        it 'stay at current_path' do
          delete :destroy, id: another_post
          expect(response).to redirect_to post_path(assigns(:post))
        end
      end
    end

    describe 'GET #index?my=true' do
      let(:posts) { create_list(:post, 2, user: @user) }
      let(:other_posts) { create_list(:post, 2) }

      before do
        posts
        other_posts
        get :index, { my: true }
      end

      it 'returns an array of user post' do
        expect(assigns(:posts)).to match_array(posts)
      end

      it 'not include in array other user posts' do
        expect(assigns(:posts)).to_not match_array(other_posts)
      end

      it 'renders my index' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'user access' do
    sign_in_user

    before do
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it_behaves_like 'public access to posts'
    it_behaves_like 'user access to posts'
  end

  describe 'guest access' do
    it_behaves_like 'public access to posts'

    describe 'GET #index?my=true' do
      it 'redirects to login' do
        get :index, { my: true }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #new' do
      it 'redirects to login' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #edit' do
      it 'redirects to login' do
        post = create(:post)
        get :edit, id: post
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it 'redirects to login' do
        post :create, post: attributes_for(:post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT #update' do
      it 'redirects to login' do
        patch :update, id: create(:post), post: attributes_for(:post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to login' do
        delete :destroy, id: create(:post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
