require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before do
    @user = create(:user)
    @post_creator = create(:user)
    @post = @post_creator.posts.create(body: Faker::Hipster.sentence)
    @comment_params = { post_id: @post.id, body: Faker::Hipster.sentence(word_count: 3) }
  end

  describe "POST comments#create" do
    context "WHEN unauthorized" do
      it "requires login" do
        post post_comments_path(@post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before do 
        login_as(@user, scope: :user)
      end

      it "publishes a comment and redirects back" do
        post post_comments_path(@post), params: { comment: @comment_params }
        
        expect(response).to have_http_status(302)
        
        follow_redirect!

        expect(flash[:notice]).to eq "You commented on the post!"
        expect(@post.comments.last.body).to eq(@comment_params[:body])
        expect(response).to have_http_status(:ok)
      end

      it "sends a notification" do
        post post_comments_path(@post), params: { comment: @comment_params }

        expect(@post_creator.notifications.count).to eq(1)
      end
    end
  end

  describe "PATCH comments#update" do
    before { @comment = @user.comments.create(@comment_params) }
    
    context "WHEN unauthorized" do
      it "requires login" do
        patch post_comment_path(@post, @comment)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "edits comment inline with AJAX" do
        patch post_comment_path(@post, @comment), 
          params: { 
            comment: { 
              post_id: @post.id, 
              body: Faker::Hipster.sentence(word_count: 3) 
            } 
          }, 
        xhr: true

        expect(response.body).to include(@post.comments.last.body)
      end
    end
  end

  describe "DELETE comments#destroy" do
    before { @comment = @user.comments.create(@comment_params) }
    
    context "WHEN unauthorized" do
      it "requires login" do
        delete post_comment_path(@post, @comment)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "deletes user's comment" do
        delete post_comment_path(@post, @comment)

        expect(flash[:notice]).to eq "Comment is successfully deleted!"
        expect(@post.comments.count).to be_zero
      end
    end
  end
end
