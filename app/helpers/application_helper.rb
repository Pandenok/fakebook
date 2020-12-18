module ApplicationHelper
  def avatar_for(user)
    if user.avatar.attached?
      user.avatar
    elsif user.male?
      "male_default.png"
    elsif user.female?
      "female_default.png"
    end
  end
end
