class SessionsController < ApplicationController
	before_filter :check_login_params, only: [:login]
	before_filter :check_logout_params, only: [:logout]
	before_action :authenticate, only: [:logout] #add other actions that require session_key

	def login
		respond_to do |format|
			#TODO add conversion for password hash
			@identity = UserIdentity.find_by! username: login_params[:username], password_hash: login_params[:password]
			#TODO add more checks such as of session exists
			@session = get_active_session @identity.user_id
				if @session.nil?
					@session = Session.new
					@session.user_id = @identity.user_id

					@session.session_key = build_session_key (@session.user_id) # get_random_string + get_random_string
					@session.expiry = Time.now + 1.day
					@session.active = true
					if @session.save
						format.json	{ render :login_success, status: :ok}
					else
						@errors = @sessions.errors.full_messages
						format.json	{ render "_common/errors", status: 500}
					end
				else
					#session was already created previously
					format.json	{ render :login_success, status: :ok}
				end
		end

	rescue ActiveRecord::RecordNotFound
		respond_to do |format|
			#TODO add insert to trace_logs	
			#return status error json view
			@errors = ['Unrecognized credentials']
			format.json	{ render "_common/errors", status: 401 }
		end
	end

	def validate

	end

	def logout
		respond_to do |format|
			@identity = UserIdentity.find_by username: (logout_params[:username])
			@session = get_active_session @identity.user_id
			# if @session.update_column(:active, false)
			# if @session && ActiveSupport::SecurityUtils.secure_compare(@session.session_key, logout_params[:session_key])
			if @session
				if Session.delete(@session.id)
					#TODO what to add as json output?
					format.json	{render :logout_success, status: :ok}
				end
			else
				@errors = ['Invalid session key']
				format.json	{ render "_common/errors", status: 401 }
			end
		end
	end

	private
		def login_params
			params.require(:user).permit(:username, :password)
		end 
		def check_login_params
			if login_params[:username].blank?
				@errors = ['No credentials']
				render "_common/errors", status: 400
			end
		end
		def logout_params
			# params.require(:session).permit(:username,:session_key)
			params.require(:session).permit(:username)
		end
		def check_logout_params
			if logout_params[:username].blank?
				@errors = ['No credentials to logout']
				render "_common/errors", status: 400
			end
		end
		def get_active_session(user_id)
			today = Time.now
			Session.where("user_id = ? and active = true AND expiry > ? ",user_id,today).take
		end

		def build_session_key(user_id)
			#this approach is deprecated. TODO revise using ActiveRecord Secure Token
			key = SecureRandom.uuid.gsub(/\-/,'')
		end
end
