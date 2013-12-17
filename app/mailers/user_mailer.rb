class UserMailer < ActionMailer::Base
  default from: 'do-not-reply@devnet.com'

  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    @url  = 'http://www.google.com'
    mail(to: email_with_name, subject: 'Welcome to DevNet!')
  end
end
