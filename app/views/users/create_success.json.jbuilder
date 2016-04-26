json.response_status "SUCCESS"
json.extract! @user_identity, :username
json.extract! @user, :status
