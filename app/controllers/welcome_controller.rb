class WelcomeController < ApplicationController
  before_filter :check_format, :except => [:index]
  
  def index
  	# NoticeMailer.test_email.deliver_now
  	# head :ok
  	respond_to do |format|
  		format.json { render status :ok }
  		format.html { render "index", status: :ok}
  	end
  end


end
