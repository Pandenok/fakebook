class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    attachments.inline['fakebook_logo_transparent.png'] = File.read('public/img/fakebook_logo_transparent.png')
    mail(to: @user.email, subject: 'Welcome to Fakebook')
  end
end
