class Username < ActiveRecord::Base
	self.primary_key='year'

	def self.next_username_in(year)
		#Note: Year column is an integer

		lastusername = Username.find_or_initialize_by(year: year)
		lastusername.increment!(:seq, 1)
		# Username.increment_counter(:seq, lastusername.seq)
		# lastusername.save
		lastusername.year.to_s.concat(lastusername.seq.to_s.rjust(4,'0'))
	end
end

