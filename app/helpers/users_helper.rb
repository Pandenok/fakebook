module UsersHelper
  private

  def user_params
    params.require(:user)
          .permit(:cover_photo,
                  :avatar,
                  :bio,
                  :workplace,
                  :hometown,
                  :relationship_status,
                  :hobbies)
  end
end
