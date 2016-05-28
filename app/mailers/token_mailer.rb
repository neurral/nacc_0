class TokenMailer < ApplicationMailer
# default from: ENV['nacc_mail_address']
default from:  %("Neurral Notifications" < #{ENV['nacc_mail_from']}>)
 
  def accesstoken_email(user)
      @user = user
  	 #TODO generate leuzin verification state
  	 # @url  = ENV['frontend_hostname'].concat('/in/').concat(@user).concat('?token=').concat(@user.token)
     # puts ENV['frontend_hostname']
     @url = ENV['frontend_hostname'] + "/#/in/#{user.username}?token=#{user.token}"
  	 mail(to: @user.email, subject: 'Neurral-Leuzin: Your access token')
  end
end
