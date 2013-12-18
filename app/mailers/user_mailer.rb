class UserMailer < ActionMailer::Base
  default from: 'do-not-reply@devnet.com'

  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    @url  = 'http://www.siliconrally.com'
    mail(to: email_with_name, subject: 'Welcome to Silicon Rally!')
  end
end
