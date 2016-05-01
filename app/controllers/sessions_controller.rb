class SessionsController < ApplicationController
	before_filter :check_login_params, only: [:login]
	before_filter :check_session_params, only: [:logout]
	
	def login
		respond_to do |format|
			#TODO add conversion for password hash
			@identity = get_identity(login_params[:username], login_params[:password])
			#TODO add more checks such as of session exists
			@session = get_active_session(@identity.user_id)
				if @session.nil?
					@session = Session.new
					@session.user_id = @identity.user_id
					#TODO replace this with a secure key generator
					@session.session_key = get_random_string + get_random_string
					@session.expiry = Time.now + 1.day
					@session.active = true
					if @session.save
						format.json	{ render :login_success, status: :ok}
					else
						@errors = ["Session creation failed"]
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

	def validate(user_id,session_key)
		# Method that can be used to validate a session_key inline, using Session.validate
		# This is intended to be used within the program only.
		#WE need to directly query the DB to check the latest information about the session.
		session = get_session(user_id,session_key)
		return (session.active && session.expiry>Time.now)  unless session == nil
	end

	def check
		# Test method for checking session activity via post. 
		respond_to do |format|
			@identity = UserIdentity.find_by! username: session_params[:username]
			@session = get_session(@identity.user_id, session_params[:session_key])
			#Instantiation of session may seem redundant; this action is for testing only
			#WE need to directly
			if validate @identity.user_id,session_params[:session_key]
			# if @session.active?
				format.json	{ render :login_success, status: :ok}
			else
				@errors = ["Invalid session"]
				format.json	{ render "_common/errors", status: 401 }
			end
		end
	end

	def logout
		respond_to do |format|
			# @identity = UserIdentity.find_by username: (logout_params[:username])
			# @session = get_active_session @identity.user_id   #just username only
			@identity = UserIdentity.find_by username: (session_params[:username])
			@session = get_session @identity.user_id, session_params[:session_key]  #require session_key too
			if validate @identity.user_id,session_params[:session_key]
				if @session.update_column(:active, false)
					format.json	{render :logout_success, status: :ok}
				else
					@errors = ["Logout failed"]
					format.json	{ render "_common/errors", status: 401 }
				end
			else
				@errors = ["Invalid session"]
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
				render "_common/errors", status: 401
			end
		end
		def check_session_params
			if session_params[:username].blank?
				@errors = ['No session provided']
				render "_common/errors", status: 401
			end
		end
		def session_params
			params.require(:session).permit(:username, :session_key)
		end

		def get_identity(username, password)
			UserIdentity.find_by! username: username, password_hash: password
		end
		def get_active_session(user_id)
			today = Time.now
			Session.where("user_id = ? and active = true AND expiry > ? ",user_id,today).take
		end
		def get_session(user_id,session_key)
			Session.where("user_id = ? and session_key = ? ",user_id,session_key).last
		end	
end
