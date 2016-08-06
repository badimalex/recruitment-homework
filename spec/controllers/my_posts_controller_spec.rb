require 'rails_helper'

RSpec.describe MyPostsController, type: :controller do
  shared_examples_for 'user access to my posts' do
    describe 'GET #index' do
      let(:posts) { create_list(:post, 2, user: @user) }
      let(:other_posts) { create_list(:post, 2) }

      before do
        posts
        other_posts
        get :index
      end

      it 'populates an array of all posts' do
        expect(assigns(:posts)).to match_array(posts)
      end

      it 'not include in array other user posts' do
        expect(assigns(:posts)).to_not include(other_posts)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'user access' do
    sign_in_user

    before do
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it_behaves_like 'user access to my posts'
  end

  describe 'guest access' do
    describe 'GET #index' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
