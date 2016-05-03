json.session do
	json.extract! @identity, :username
	json.extract! @session, :session_key, :expiry, :created_at
end

