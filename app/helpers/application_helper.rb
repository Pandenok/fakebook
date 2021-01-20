module ApplicationHelper
  def avatar_for(user, size=40)
    if user.avatar.attached?
      user.avatar.variant(resize: "#{size}x#{size}!")
    elsif user.female?
      'female_default.png'
    else
      'male_default.png'
    end
  end
end
