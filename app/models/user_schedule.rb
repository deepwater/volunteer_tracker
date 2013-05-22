class UserSchedule < ActiveRecord::Base

	belongs_to :user
	belongs_to :department_block

	after_create :deliver_email
	after_destroy :unschedule_email

	def deliver_email
		UserScheduleMailer.schedule_email(self).deliver
	end

	def unschedule_email
		UserScheduleMailer.unschedule_email(self).deliver
	end
	
end
