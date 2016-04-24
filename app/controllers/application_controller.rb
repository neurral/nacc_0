class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
protect_from_forgery with: :null_session
  

  def check_format
      render :nothing => true, :status => 406 unless request.format.symbol == :json
  end
end
