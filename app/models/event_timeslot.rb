class EventTimeslot < ActiveRecord::Base
	has_many :users
	has_many :users, :through => :user_availabilities
	belongs_to :department_block

	def readable_time 
		t = Time.at(self.utc_date).in_time_zone

		return t.strftime("%l.%M%P %A, %-d %B, %Y")
	end
end
