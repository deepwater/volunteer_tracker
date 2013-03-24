class EventTimeslot < ActiveRecord::Base
	has_many :user_availabilities
	has_many :users, :through => :user_availabilities
	has_many :department_block

	def readable_time 
		t = Time.at(self.utc_date).in_time_zone

		return t.strftime("%l.%M%P %A, %-d %B, %Y")
	end

	def readable_short_time
		t = Time.at(self.utc_date).in_time_zone

		return t.strftime("%l.%M%P")
	end
end
