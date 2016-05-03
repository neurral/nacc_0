class ApplicationController < ActionController::Base
# Prevent CSRF attacks by raising an exception.
# For APIs, you may want to use :null_session instead.
#protect_from_forgery with: :exception
	protect_from_forgery with: :null_session

	def check_format
		if ENV['nacc_allow_non_json'] == 'no'
 			# render :nothing => true, :status => 406 unless request.format.symbol == :json
 			render :nothing => true, :status => 406 unless params[:format] == 'json' || request.headers["Accept"] =~ /json/
		else
			#do something for non json 
		end
	end

	def get_random_string
      ('a'..'z').to_a.shuffle[0,8].join
    end

end
