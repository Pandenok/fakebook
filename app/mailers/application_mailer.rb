class ApplicationMailer < ActionMailer::Base
  default from: 'welcome_to@fakebook.com'
  layout 'mailer'
end
