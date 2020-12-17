module UsersHelper
  private

  def user_params
    params.require(:user).permit(:cover_photo)
  end
end
