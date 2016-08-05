require 'rails_helper'

RSpec.describe PostsController, type: :controller do
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

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new post to @post' do
      expect(assigns(:post)).to be_a_new(Post)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    let(:post) { create(:post) }
    before { get :edit, id: post }

    it 'assigns the requested post to @post' do
      expect(assigns(:post)).to eq post
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new post in the database' do
        expect { post :create, post: attributes_for(:post) }.to change(Post, :count).by(1)
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
    sign_in_user

    let(:post) { create(:post, title: 'Original title', body: 'Original body') }

    context 'valid attributes' do
      it 'assigns the requested post to @post' do
        patch :update, id: post, post: attributes_for(:post)
        expect(assigns(:post)).to eq post
      end

      it 'changes post attributes' do
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
      it 'does not change post attributes' do
        post.reload
        expect(post.title).to eq 'Original title'
        expect(post.body).to eq 'Original body'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'Delete #destroy' do
    sign_in_user

    let(:post) { create(:post) }

    it 'deletes post' do
      post
      expect { delete :destroy, id: post }.to change(Post, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: post
      expect(response).to redirect_to posts_path
    end
  end
end
