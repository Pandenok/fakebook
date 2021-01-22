require 'rails_helper'

RSpec.describe "Posts", type: :request do
  before do
    @user = create(:user)
    @post = @user.posts.create(body: "Jean shorts trust fund fanny pack poutine. Lumbersexual cred lomo. Poutine diy typewriter.")
    @notification = Notification.create(
      sent_to: @user,
      sent_by: create(:user),
      action: "commented",
      notifiable: @post
    )
  end

  describe "GET posts#index" do
    context "WHEN unauthorized" do
      it "requires login" do
        get posts_path

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before do
        @friend = create(:user)
        @user.friends << @friend
        @friend_post = @user.posts.create(body: "Brooklyn master loko. Marfa viral sartorial art party quinoa cred single origin coffee.")
        @stranger = create(:user)
        @stranger_post = @stranger.posts.create(body: "Five dollar toast echo chambray vegan kitsch mumblecore blog semiotics.")
        login_as(@user, scope: :user)
      end

      it "shows user's and friends' posts" do
        get posts_path
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(@post.body)
        expect(response.body).to include(@friend_post.body)
        expect(response.body).to_not include(@stranger_post.body)
      end
    end
  end

  describe "GET posts#show" do
    context "WHEN unauthorized" do
      it "requires login" do
        get post_path(@post), params: { notification_id: @notification.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "shows post" do
        get post_path(@post), params: { id: @post.id, notification_id: @notification.id }
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(@post.body)
      end

      it "marks all the notifications about post as 'seen'" do
        get post_path(@post), params: { notification_id: @notification.id }
        
        expect(@user.notifications.last.action).to eq("commented")
        expect(@user.notifications.last.status).to eq("seen")
      end
    end
  end

  describe "GET posts#new" do
    context "WHEN unauthorized" do
      it "requires login" do
        get new_post_path

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "returns http success" do
        get new_post_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST posts#create" do
    context "WHEN unauthorized" do
      it "requires login" do
        post posts_path

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      context "WHEN all params are valid" do
        it "creates a new text post" do
          post posts_path, params: { post: { user_id: @user.id, body: Faker::Hipster.sentence } }

          expect(response).to have_http_status(302)
          
          follow_redirect!

          expect(@user.posts.count).to eq(2)
          expect(flash[:notice]).to eq "Post successfully created!"
          expect(response).to have_http_status(:ok)
        end

        it "creates a new post with image" do
          post posts_path, params: { 
            post: { 
              user_id: @user.id, 
              images: [Rack::Test::UploadedFile.new('./spec/images/smile.png', 'image/png')] 
            } 
          }

          expect(response).to have_http_status(302)
          
          follow_redirect!

          expect(flash[:notice]).to eq "Post successfully created!"
          expect(response).to have_http_status(:ok)
        end
      end

      context "WHEN params are invalid" do
        it "raises an error" do
          post posts_path, params: { post: { user_id: @user.id, body: '' } }
          
          expect(flash[:alert]).to eq "Something went wrong..."
        end
      end
    end
  end

  describe "PATCH posts#update" do
    context "WHEN unauthorized" do
      it "requires login" do
        put post_path(@post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      context "WHEN all params are valid" do
        before { @updated_post_body = "Schlitz before they sold out fashion axe chambray trust fund phlogiston yr." }

        it "updates user's post" do
          put post_path(@post), params: { post: { body: @updated_post_body } }

          expect(response).to have_http_status(302)
          
          follow_redirect!

          expect(response).to have_http_status(:ok)
          expect(flash[:notice]).to eq "Post successfully updated!"
          expect(response.body).to include(@updated_post_body)
        end
      end

      context "WHEN params are invalid" do
        it "raises an error" do
          put post_path(@post), params: { post: { body: '' } }
          
          expect(flash[:alert]).to eq "Something went wrong..."
        end
      end
    end
  end

  describe "DELETE posts#destroy" do
    context "WHEN unauthorized" do
      it "requires login" do
        delete post_path(@post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "deletes user's post" do
        delete post_path(@post)

        expect(response).to have_http_status(302)
        
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq "Post was successfully deleted!"
        expect(response.body).to_not include(@post.body)
      end
    end
  end

  describe "DELETE posts#delete_image_attachment" do
    context "WHEN unauthorized" do
      it "requires login" do
        delete delete_image_attachment_post_path(@post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before do
        @post.images.attach(Rack::Test::UploadedFile.new('./spec/images/smile.png', 'image/png'))
        login_as(@user, scope: :user)
      end

      it "removes attached images" do
        delete delete_image_attachment_post_path(@post), params: { image_id: @post.images.first.id }

        expect(response).to have_http_status(302)
        
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(@post.images.count).to be_zero
      end
    end
  end
end
