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

	protected

	# for controllers aside from session management where a session_key is expected, call
	# :authenticate method as a before_action
	def authenticate
		authenticate_token || render_unauthorized
	end

	def authenticate_token
		authenticate_with_http_token do |token, options|
			Session.find_by(session_key: token)
		end
	end

	def render_unauthorized
		self.headers['WWW-Authenticate'] = 'Token realm="Application"'
		@errors = ['Bad credentials']
		render "_common/errors", status: 401
	end

end
