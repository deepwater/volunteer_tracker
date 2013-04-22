class UserSchedule < ActiveRecord::Base

	belongs_to :user
	belongs_to :department_block

	after_create :deliver_email

	def deliver_email
		UserScheduleMailer.schedule_email(self)
	end
end
