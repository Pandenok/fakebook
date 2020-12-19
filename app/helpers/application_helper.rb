module ApplicationHelper
  def avatar_for(user, size=40)
    if user.avatar.attached?
      user.avatar.variant(resize: "#{size}x#{size}!")
    elsif user.male?
      "https://scontent-fco1-1.xx.fbcdn.net/v/t1.30497-1/c59.0.200.200a/p200x200/84241059_189132118950875_4138507100605120512_n.jpg?_nc_cat=1&ccb=2&_nc_sid=7206a8&_nc_ohc=AyinvfZOthkAX-bE8gJ&_nc_ht=scontent-fco1-1.xx&tp=27&oh=2336688463c324b8d32649616ba65ccf&oe=60026E04"
    elsif user.female?
      "https://scontent-fco1-1.xx.fbcdn.net/v/t1.30497-1/c59.0.200.200a/p200x200/84688533_170842440872810_7559275468982059008_n.jpg?_nc_cat=1&ccb=2&_nc_sid=7206a8&_nc_ohc=nlYajRCik54AX8LkG6n&_nc_ht=scontent-fco1-1.xx&tp=27&oh=4fd2a0042b42339ec513bfcbc2f80a7a&oe=6003B9D4"
    end
  end
end
