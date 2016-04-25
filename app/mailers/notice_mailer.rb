class NoticeMailer < ApplicationMailer
default from: ENV['nacc_mail_address']
 
  def welcome_email(user)
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def test_email
    mail(to: 'la.f.bermejo@gmail.com', subject: 'WTest emal')
  end
end
