class WelcomeController < ApplicationController
  before_filter :check_format
  
  def index
  	#NoticeMailer.test_email.deliver_now
  	head :ok
  end


end
