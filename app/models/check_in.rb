class CheckIn < ActiveRecord::Base

	belongs_to :user_schedule
	belongs_to :user

	before_save :check_status

	has_many :flags

	def checked_out?
		status == "2"
	end

	def hours_worked
		if checked_out?
			((check_out_time - created_at).to_d/3600).truncate(2) rescue "0"
		else
			"0"
		end
	end

  private

	def check_status
		if (self.status_changed? && self.status == "2")
			self.check_out_time =  DateTime.now
		end
	end
end	
