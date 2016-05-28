class NoticeMailer < ApplicationMailer
default from:  %("Neurral Notifications" < #{ENV['nacc_mail_from']}>)
 
  def register_email(user)
    @user = user
    @help_mail = "support@#{ENV['nacc_mail_domain']}"
    email_with_name = %("#{@user.first_name}  #{@userlast_name}" <#{@user.email}>)
	mail(to: email_with_name, subject: 'Neurral-Leuzin: Your registration')
  end

end
