class User < ActiveRecord::Base
	enum status: { 
		for_auth: 0, 
		active: 1,
		inactive: 2,
		terminated: 9
	}
	enum gender: {prefer_not_to_disclose: 0, male: 1, female: 2, not_sure: 3}
	enum user_type: {guest: 0, employee: 1, exec: 2, sysadmin: 3}

	# TODO add validations
	validates :first_name, presence: true

end
