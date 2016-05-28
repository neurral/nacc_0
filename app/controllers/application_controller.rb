class ApplicationController < ActionController::Base
# Prevent CSRF attacks by raising an exception.
# For APIs, you may want to use :null_session instead.
#protect_from_forgery with: :exception
protect_from_forgery with: :null_session
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

@url = ENV['frontend_hostname']

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

	def build_token
			#this approach is deprecated. TODO revise using ActiveRecord Secure Token
			key = SecureRandom.uuid.gsub(/\-/,'')
	end

	def record_not_found
      render json: "{Not Found}", status: 404
    end

	protected

	# for controllers aside from session management where a session_key is expected, call
	# :authenticate method as a before_action
	def authenticate
		authenticate_token || render_unauthorized
	end

	def authenticate_token
		authenticate_with_http_token do |token, options|
			# Session.find_by(session_key: token)
			puts "Token:"+token
			if token.nil?
				puts "nil token"
				return false
			else
				#add the token as a class variable so we can use it in UserController
				@token = token
				puts token
			User.find_by(token: token)
			# User.where("token = ? AND status != ? AND token_expiry > ? ",token,9,Time.now).take
			end
		end
	end

	def render_unauthorized
		self.headers['WWW-Authenticate'] = 'Token realm="NeurralToken"'
		@errors = ['Invalid username/token']
		render "_common/errors", status: 401
	end

end
