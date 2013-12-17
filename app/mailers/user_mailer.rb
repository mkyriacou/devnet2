class UserMailer < ActionMailer::Base
  default from: 'strattica@gmail.com'

  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    @url  = 'http://www.google.com'
    mail(to: email_with_name, subject: 'Welcome to Google ... ok maybe you have been here before')
  end
end
