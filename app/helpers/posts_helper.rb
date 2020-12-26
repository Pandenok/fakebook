module PostsHelper
  def post_params
    params.require(:post).permit(:user_id, :body, images: [])
  end
end
