json.response_status "SUCCESS"
json.session do
	json.extract! @identity, :username
	json.extract! @session, :session_key, :created_at, :active
end

