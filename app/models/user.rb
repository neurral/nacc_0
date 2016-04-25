class User < ActiveRecord::Base
	enum status: { 
		for_init: 0, 
		active: 1,
		inactive: 2,
		terminated: 9
	}
	validates :first_name, presence: true
end
