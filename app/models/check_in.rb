class CheckIn < ActiveRecord::Base

	validates_uniqueness_of :user_schedule_id
	belongs_to :user_schedule

	before_save :check_status

	has_many :flags
	def check_status

		if (self.status_changed? && self.status == "2")
			self.check_out_time =  Time.now.strftime("%I:%M %p")
		end
	end

end	
