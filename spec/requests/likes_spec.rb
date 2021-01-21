require 'rails_helper'

RSpec.describe "Likes", type: :request do
  before do
    @user = create(:user)
    @post_creator = create(:user)
    @post = @post_creator.posts.create(body: Faker::Hipster.sentence)
  end

  describe "POST likes#create" do
    context "WHEN unauthorized" do
      it "requires login" do
        post post_likes_path(@post)
        
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }
      
      it "puts like and redirects back" do
        post post_likes_path(@post)

        expect(response).to have_http_status(302)

        follow_redirect!

        expect(flash[:notice]).to eq "You liked the post!"
        expect(response).to have_http_status(:ok)
      end

      it "sends a notification" do
        post post_likes_path(@post)

        expect(@post_creator.notifications.count).to eq(1)
      end
    end
  end

  describe "DELETE likes#destroy" do
    before { @like = @user.likes.create(post_id: @post.id) }

    context "WHEN unauthorized" do
      it "it requires login" do
        delete post_like_path(@post, @like)
        
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }
      
      it "removes like and redirects back" do
        delete post_like_path(@post, @like)

        expect(response).to have_http_status(302)

        follow_redirect!

        expect(flash[:notice]).to eq "You unliked the post!"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
