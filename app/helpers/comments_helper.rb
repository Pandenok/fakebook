module CommentsHelper
  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :body)
  end
end
